module WLang
  #
  # Implements the hosted language of WLang. The hosted language is
  # responsible of evaluating expressions. 
  #
  # This default implementation implements the ruby hosted language, 
  # using instance_eval, delegating missing sub expressions to the current 
  # scope.
  #
  # This class is not thread safe. It is intended to be subclassed for 
  # providing a main scope, accessible in all parser states/templates.
  #
  class HostedLanguage < ::WLang::BasicObject
    
    # Delegates the missing lookup to the current parser scope
    # or raises a NoMethod
    def method_missing(name, *args, &block)
      if @parser_state and args.empty? and block.nil?
        if @parser_state.scope.has_key?(name.to_s)
          @parser_state.scope[name.to_s]
        else
          variable_missing(name)
        end
      else
        super(name, *args, &block)
      end
    end
    
    # Called when a variable cannot be found. By default, it raises an
    # UndefinedVariableError. This method is intended to be overriden 
    # for handling such a situation more friendly.
    def variable_missing(name)
      Kernel.raise ::WLang::UndefinedVariableError.new(nil, nil, nil, name)
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
      @parser_state = parser_state
      instance_eval(expression)
    rescue ::WLang::Error => ex
      ex.parser_state = parser_state
      ex.expression = expression if ex.respond_to?(:expression=)
      Kernel.raise ex
    rescue Exception => ex
      Kernel.raise ::WLang::EvalError.new(ex.message, parser_state, expression, ex)
    ensure
      @parser_state = nil
    end
    
  end # class HostedLanguage
end # module WLang