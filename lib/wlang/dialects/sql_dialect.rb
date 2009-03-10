module WLang
  class EncoderSet
    
    # Encoders for ruby
    module SQL
  
      # Default encoders  
      DEFAULT_ENCODERS = {"single-quoting" => :single_quoting}
  
      # Upcase encoding
      def self.single_quoting(src, options); src.gsub("'","\\\\'"); end
  
    end # module SQL
    
    # Encoders for ruby
    module SQL::Sybase
  
      # Default encoders  
      DEFAULT_ENCODERS = {"single-quoting" => :single_quoting}
  
      # Upcase encoding
      def self.single_quoting(src, options); src.gsub("'","''"); end
  
    end # module SQL::Sybase  
    
  end  
  class RuleSet
    
    # Defines rulset of the wlang/ruby dialect
    module SQL
    
        # Default mapping between tag symbols and methods
        DEFAULT_RULESET = {}
    
    end # module SQL
    
  end
end
