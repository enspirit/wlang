module WLang
  class EncoderSet
    
    # Encoders for ruby
    module Ruby
  
      # Default encoders  
      DEFAULT_ENCODERS = {"single-quoting" => :single_quoting, 
                          "double-quoting" => :double_quoting, 
                          "regex-escaping" => :regex_escaping}
  
      # Single-quoting encoding
      def self.single_quoting(src, options); src.gsub(/([^\\])'/,%q{\1\\\'}); end
  
      # Double-quoting encoding
      def self.double_quoting(src, options); src.gsub('"','\"'); end
  
      # Regexp-escaping encoding
      def self.regex_escaping(src, options); Regexp.escape(src); end
  
    end # module Ruby  
  
  end
  class RuleSet

    # Defines rulset of the wlang/ruby dialect
    module Ruby
    
        # Default mapping between tag symbols and methods
        DEFAULT_RULESET = {}
    
    end # module Ruby
    
  end
end