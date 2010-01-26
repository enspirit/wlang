module WLang
  class EncoderSet
    
    # Defines encoders of the plain-text dialect
    module PlainText

      # Default encoders  
      DEFAULT_ENCODERS = {"upcase"      => :upcase, 
                          "downcase"    => :downcase, 
                          "capitalize"  => :capitalize,
                          "camel"       => :camel_case,
                          "camel-case"  => :camel_case,
                          "upper-camel" => :camel_case,
                          "lower-camel" => :lower_camel_case}
  
      # Upcase encoding
      def self.upcase(src, options); src.upcase; end
  
      # Downcase encoding
      def self.downcase(src, options); src.downcase; end
  
      # Capitalize encoding
      def self.capitalize(src, options); src.capitalize; end
  
      # Converts a string as CamelCase
      def self.camel_case(src, options)
        src.gsub!(/[^a-zA-Z\s]/," ")
        src = " " + src.split.join(" ")
        src.gsub!(/ (.)/) { $1.upcase }    
      end
      
      # Converts a string to lower camelCase
      def self.lower_camel_case(src, options)
        camel_case(src, options).gsub(/^([A-Z])/){ $1.downcase }
      end
    
    end # module PlainText
    
  end
  class RuleSet
    
    # Defines rulset of the plain-text dialect
    module PlainText
    
      # Default mapping between tag symbols and methods
      DEFAULT_RULESET = {'+' => :upcase, '-' => :downcase}
  
      # Upcase rule as <tt>+{wlang/hosted}</tt>
      def self.upcase(parser, offset)
        expression, reached = parser.parse(offset, "wlang/ruby")
        value = parser.evaluate(expression)
        value = value.nil? ? "" : value.to_s
        result = WLang::EncoderSet::PlainText.upcase(value)
        [result, reached]
      end
  
      # Downcase rule as <tt>-{wlang/hosted}</tt>
      def self.downcase(parser, offset)
        expression, reached = parser.parse(offset, "wlang/ruby")
        value = parser.evaluate(expression)
        value = value.nil? ? "" : value.to_s
        result = EncoderSet::PlainText.downcase(value)
        [result, reached]
      end
  
    end # module PlainText
    
  end
end