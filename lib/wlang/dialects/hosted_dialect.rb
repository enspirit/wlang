module WLang
  class EncoderSet
    
    # Encoders for ruby
    module Hosted
  
      # Default encoders  
      DEFAULT_ENCODERS = {"main-encoding"  => :main_encoding,
                          "single-quoting" => :single_quoting, 
                          "double-quoting" => :double_quoting, 
                          "regex-escaping" => :regex_escaping,
                          "method-case"    => :method_case}
  
      # No-op encoding here
      def self.main_encoding(src, options); src; end
  
      # Single-quoting encoding
      def self.single_quoting(src, options); src.gsub(/([^\\])'/,%q{\1\\\'}); end
  
      # Double-quoting encoding
      def self.double_quoting(src, options); src.gsub('"','\"'); end
  
      # Regexp-escaping encoding
      def self.regex_escaping(src, options); Regexp.escape(src); end
      
      # Converts any source to a typical ruby method name
      def self.method_case(src, options)
        src.strip.gsub(/[^a-zA-Z0-9\s]/," ").
                  gsub(/([A-Z])/){ " " + $1.downcase}.
                  strip.
                  gsub(/^([^a-z])/){ "_" + $1 }.
                  gsub(/\s+/){"_"}
      end
      
  
    end # module Hosted
  
  end
  class RuleSet

    # Defines rulset of the wlang/ruby dialect
    module Hosted
    
        # Default mapping between tag symbols and methods
        DEFAULT_RULESET = {}
      
    end # module Hosted
    
  end # class RuleSet
end # module WLang
