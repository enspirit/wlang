module WLang
  #
  # Implements the hosted language abstraction of WLang. The hosted language is
  # mainly responsible of evaluating expressions (see evaluate). This abstraction
  # may be implemented by a user's own class, providing that it respected the 
  # evaluate method specification.
  #
  # This default implementation implements the ruby hosted language. It works 
  # with ::WLang::HostedLanguage::DSL, which uses instance_eval for evaluating
  # the expression. Calls to missing methods (without parameter and block) are
  # converted in scope lookups. The DSL class is intended to be used as an open
  # class. Doing so allows providing common utils to all templates, as illustrated
  # below:
  #
  #   # Reopening the DSL class allows providing tools
  #   class ::WLang::HostedLanguage::DSL < ::WLang::BasicObject
  #
  #     # Simulates a 'now' variable in all template scopes (this is not the best
  #     # way to do it, see later)
  #     def now
  #       Time.now
  #     end
  #
  #     # Something non-deterministic, for the sake of the example
  #     def lucky
  #       Kernel.rand <= 0.5
  #     end
  #
  #   end
  #
  #   # Typical usage in templates
  #   <html>
  #     [...]
  #     <p>The current time is #{now}</p>
  #     [...]
  #     <p>You are ?{do_it}{lucky}{not lucky}</p>
  #     [...]
  #   </html>
  #
  # ATTENTION: in order to avoid strange name conflicts between wlang templates and
  # ruby Kernel/Object methods, the DSL class is a BasicObject. It means that few 
  # methods are known in its own scope. Always use Kernel.puts, Kernel.raise, ...
  # explicitely when extending the DSL. Moreover, methods added to the DSL will 
  # always hide user's variables in the scope as they have the priority due to the
  # implementation, as the following example illustrates (same DSL extension than
  # before):
  #
  #    <html>
  #      <!-- following line will show the time, not 'something' -->
  #      ={'something' as now}{ ${now} }
  #    </html>
  #
  # An alternative for installing low-priority variables and tools is to reopen the
  # HostedLanguage class itself and to override variable_missing:
  #
  #   class WLang::HostedLanguage
  #
  #     # Low-priority now2 variable
  #     def now2
  #       Time.now
  #     end
  #
  #     # Low-priority variables are checked before raising an UndefinedVariableError
  #     def variable_missing(name)
  #       case name
  #         when :who2, ...
  #           self.send(name)
  #         else
  #           raise ::WLang::UndefinedVariableError.new(nil, nil, nil, name)
  #       end
  #     end 
  #
  #   end
  #
  # This class is thread safe, meaning that the same hosting language instance may be 
  # safely shared by concurrent wlang parsers. Extending or re-opening this class and using
  # instance variables will make it non thread-safe.
  #
  class HostedLanguage
    
    # The hosted language DSL, interpreting expressions
    class DSL < ::WLang::BasicObject
      
      # Creates a DSL instance for a given hosted language and 
      # parser state
      def initialize(hosted, parser_state)
        @hosted, @parser_state = hosted, parser_state
      end
      
      # Delegates the missing lookup to the current parser scope or raises an
      # UndefinedVariableError (calls @hosted.variable_missing precisely)
      def method_missing(name, *args, &block)
        if @parser_state and args.empty? and block.nil?
          if effname = knows?(name)
            @parser_state.scope[effname]
          else
            @hosted.variable_missing(name)
          end
        else
          super(name, *args, &block)
        end
      end
    
      # Checks if a variable is known in the current parser scope
      def knows?(name)
        if @parser_state.scope.has_key?(name)
          name
        elsif @parser_state.scope.has_key?(name.to_s) 
          name.to_s
        else
          nil
        end
      end
    
      # Evaluates an expression
      def __evaluate(__expression__)
        __result__ = instance_eval(__expression__)
        
        # backward compatibility with >= 0.8.4 where 'using self'
        # was allowed. This will be removed in wlang 1.0.0
        if __result__.object_id == self.object_id
          Kernel.puts "Warning: using deprecated 'using self' syntax (#{@parser_state.where})\n"\
                      "will be removed in wlang 1.0.0. Use 'share all', extends "\
                      "::WLang::HostedLanguage::DSL with useful methods or create your own"\
                      " hosted language."
          __result__ = @parser_state.scope.to_h
        end
        
        __result__
      rescue ::WLang::Error => ex
        ex.parser_state = @parser_state
        ex.expression = __expression__ if ex.respond_to?(:expression=)
        Kernel.raise ex
      rescue Exception => ex
        Kernel.raise ::WLang::EvalError.new(ex.message, @parser_state, __expression__, ex)
      end
      
    end # class DSL
    
    #
    # Called when a variable cannot be found (name is a Symbol object). This default
    # implementation raises an UndefinedVariableError. This method is intended to be 
    # overriden for handling such a situation more friendly or for installing 
    # low-priority global variables (see class documentation).
    #
    def variable_missing(name)
      raise ::WLang::UndefinedVariableError.new(nil, nil, nil, name)
    end
      
    #
    # Evaluates a given expression in the context of a given
    # parser state.
    #
    # This method should always raise 
    # - an UndefinedVariableError when a given template variable cannot be found.
    # - an EvalError when something more severe occurs
    #
    def evaluate(expression, parser_state)
      DSL.new(self, parser_state).__evaluate(expression)
    end
    
  end # class HostedLanguage
end # module WLang