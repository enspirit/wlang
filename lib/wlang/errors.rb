module WLang
  
  # Main error of all WLang errors.
  class Error < StandardError; end
  
  # Raise when something fails when evaluting through the parser context
  class EvalError < StandardError; end
  
  # Error raised by a WLang parser instanciation when an error occurs. 
  class ParseError < StandardError;  
    
    attr_accessor :line, :column
    
  end
  
end # module WLang
