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
  # converted in scope lookups. The DSL class is strictly private, as it uses 
  # a somewhat complex ruby introspection mechanism to ensure that scoping will
  # not be perturbated by Kernel methods and Object private methods even if 
  # additional gems are loaded later.
  #
  # If you want to intall low-priority variables and tools available in all wlang
  # templates (global scoping) you can reopen the HostedLanguage class itself and
  # override variable_missing. Note that "low-priority" means that these methods
  # will be hidden if a user installs a variable with the same name in its template.
  #
  #   class WLang::HostedLanguage
  #
  #     # Low-priority now variable
  #     def now
  #       Time.now
  #     end
  #
  #     # Low-priority variables are checked before raising an UndefinedVariableError
  #     def variable_missing(name)
  #       case name
  #         when :who, ...
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
    class DSL
      
      # Methods that we keep
      KEPT_METHODS = [ "__send__", "__id__", "instance_eval", "initialize", "object_id", 
                       "singleton_method_added", "singleton_method_undefined", "method_missing",
                       "__evaluate__", "knows?"]

      class << self
        def __clean_scope__
          # Removes all methods that are not needed to the class
          (instance_methods + private_instance_methods).each do |m|
            m_to_s = m.to_s
            undef_method(m_to_s.to_sym) unless ('__' == m_to_s[0..1]) or KEPT_METHODS.include?(m_to_s)
          end
        end
      end
      
      # Creates a DSL instance for a given hosted language and 
      # parser state
      def initialize(hosted, parser_state)
        @hosted, @parser_state = hosted, parser_state
        class << self
          __clean_scope__
        end
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
      def __evaluate__(__expression__)
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
      ::WLang::HostedLanguage::DSL.new(self, parser_state).__evaluate__(expression)
    end
    
  end # class HostedLanguage
end # module WLang