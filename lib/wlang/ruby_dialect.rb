module WLang

class Encoders
  
  # Defines encoders of the plain-text dialect
  module Ruby
  
    # Default encoders  
    DEFAULT_ENCODERS = {"single-quoting" => :single_quoting, 
                        "double-quoting" => :double_quoting, 
                        "regex-escaping" => :regex_escaping}
    
    # Upcase encoding
    def self.single_quoting(src, options); src.gsub("'","\\\\'"); end
    
    # Downcase encoding
    def self.double_quoting(src, options); src.gsub('"','\"'); end
    
    # Capitalize encoding
    def self.regex_escaping(src, options); Regexp.escape(src); end
    
  end # module PlainText  

end # class Encoders

class RuleSet
  
  # Defines rulset of the plain-text dialect
  module Ruby
    
    # Default mapping between tag symbols and methods
    DEFAULT_RULESET = {}
    
  end # module PlainText
  
end # class RuleSet

end # module WLang