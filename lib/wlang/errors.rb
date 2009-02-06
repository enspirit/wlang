module WLang
  
  # Main error of all WLang errors.
  class Error < StandardError; end
  
  # Error raised by a WLang parser instanciation when an error occurs. 
  class ParseError < StandardError; end
  
end # module WLang