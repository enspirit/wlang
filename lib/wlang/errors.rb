module WLang
  
  # Main error of all WLang errors.
  class Error < StandardError
    
    # The parser state whe this error has been raised
    attr_accessor :parser_state
    
    # Optional cause (other lower level exception)
    attr_accessor :cause
    
    # Creates an error instance with a given parser state
    def initialize(msg = nil, parser_state = nil, cause = nil)
      super(msg)
      @parser_state = parser_state
      @cause = cause
    end
    
  end # class Error
  
  #
  # Raised by hosted languages when something fails during 
  # evaluation.
  #
  class EvalError < ::WLang::Error
    
    # The expression whose evaluation failed
    attr_accessor :expression
    
    # Creates an error instance with an optional expression that
    # failed
    def initialize(msg = nil, parser_state = nil, expression = nil, cause = nil)
      super(msg, parser_state, cause)
      @expression = expression
    end
    
    def to_s
      "Evaluation of #{@expression} failed, #{@cause ? @cause.message : ''}"
    end
    
  end # class EvalError
  
  #
  # Raised when a variable may not be found in the current 
  # parser scope
  #
  class UndefinedVariableError < ::WLang::EvalError
    
    # Name of the variable that could not be found
    attr_accessor :variable
    
    # Creates an error instance with an optional variable name
    def initialize(msg = nil, parser_state = nil, expression = nil, variable = nil)
      super(msg, parser_state, expression)
      @variable = variable
    end
    
    def to_s
      "Unable to find variable #{@variable}"
    end
    
  end # class UndefinedVariableError
  
  # Error raised by a WLang parser instanciation when an error occurs. 
  class ParseError < ::WLang::Error
    
    # Where did the parsing failed
    attr_accessor :line, :column
    
  end # class ParseError
  
end # module WLang