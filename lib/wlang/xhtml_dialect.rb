module WLang

class Encoders
  
  # Defines encoders of the plain-text dialect
  module XHtml
  
    # Default encoders  
    DEFAULT_ENCODERS = {"main-encoding"     => :entities_encoding, 
                        "entities-encoding" => :entities_encoding}
    
    # Upcase encoding
    def self.entities_encoding(src, options); 
      src
    end
    
  end # module PlainText  

end # class Encoders

class RuleSet
  
  # Defines rulset of the plain-text dialect
  module XHtml
    
    # Default mapping between tag symbols and methods
    DEFAULT_RULESET = {}
    
  end # module PlainText
  
end # class RuleSet

end # module WLang