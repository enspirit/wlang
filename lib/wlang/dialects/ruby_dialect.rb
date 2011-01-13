module WLang
  class EncoderSet
    
    # Encoders for ruby
    module Ruby
  
      # Default encoders  
      DEFAULT_ENCODERS = {"main-encoding"  => :main_encoding,
                          "single-quoting" => :single_quoting, 
                          "double-quoting" => :double_quoting, 
                          "regex-escaping" => :regex_escaping,
                          "method-case"    => :method_case,
                          "literal"        => :to_literal}
  
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
      
      # Ruby classes for which value.inspect will work for returning
      # a valid literal
      SAFE_LITERAL_CLASSES = {}
      [NilClass, TrueClass, FalseClass,
       Fixnum, Bignum,
       Float, 
       String,
       Symbol,
       Class, 
       Module,
       Regexp].each{|c| SAFE_LITERAL_CLASSES[c] = true}
       
      #
      # Converts _value_ to a ruby literal and returns it.
      #
      # Behavior of the algorithm when th value cannot be recognized depends
      # on the :fallback option:
      #   * when set to :fail, it raises a NoSuchLiteralError
      #   * when set to :inspect, it returns <code>value.inspect</code>
      #   * when set to :marshal it uses <code>Marshal::dump(value)</code>
      #   * when set to :json it uses <code>JSON::generate(value)</code>
      #
      def self.to_literal(value, options = {:fallback => :fail})
        if value.respond_to?(:to_ruby_literal)
          value.to_ruby_literal
        elsif value.respond_to?(:to_ruby)
          value.to_ruby
        elsif value == (1.0/0)
          return '(1.0/0)'
        elsif value == -(1.0/0)
          return '(-1.0/0)'
        elsif SAFE_LITERAL_CLASSES.key?(value.class)
          value.inspect
        elsif value.kind_of?(Array)
          "[" + value.collect{|v| to_literal(v, options)}.join(', ') + "]"
        elsif value.kind_of?(Hash)
          "{" + value.collect{|pair| "#{to_literal(pair[0], options)} => #{to_literal(pair[1], options)}"}.join(', ') + "}"
        elsif value.kind_of?(Date)
          "Date::parse(#{value.to_s.inspect})"
        elsif value.kind_of?(Time)
          "Time::parse(#{value.inspect.inspect})"
        else
          case options[:fallback]
            when :to_s
              value.to_s
            when :inspect
              value.inspect
            when :marshal
              "Marshal::load(#{Marshal::dump(value).inspect})"
            when :json
              require 'json'
              JSON::generate(value)
            when :fail, nil
              raise WLang::Error, "Unable to convert #{value.inspect} to a ruby literal"
            else
              raise ArgumentError, "Invalid fallback option #{options[:fallback]}"
          end
        end
      end
  
    end # module Ruby  
  
  end
  class RuleSet

    # Defines rulset of the wlang/ruby dialect
    module Ruby
    
        # Default mapping between tag symbols and methods
        DEFAULT_RULESET = {'+' => :inclusion}
    
        # Rule implementation of <tt>+{wlang/ruby}</tt>.
        def self.inclusion(parser, offset)
          expression, reached = parser.parse(offset, "wlang/hosted")
          value = parser.evaluate(expression)
          result = WLang::EncoderSet::Ruby.to_literal(value)
          [result, reached]
        end
  
    end # module Ruby
    
  end # class RuleSet
end # module WLang
