require "yaml"
module WLang
  class EncoderSet
    module YAML
  
      # Default encoders  
      DEFAULT_ENCODERS = {}
  
    end # module YAML
  end
  class RuleSet
    module YAML
    
        # Default mapping between tag symbols and methods
        DEFAULT_RULESET = {'+' => :inclusion}
    
        # Rule implementation of <tt>+{wlang/ruby}</tt>.
        def self.inclusion(parser, offset)
          expression, reached = parser.parse(offset, "wlang/hosted")
          value = parser.evaluate(expression)
          col = parser.buffer.__wlang_column_of(parser.buffer.length)
          result = value.to_yaml.
                         gsub(/^\s*---\s*|\n$/,"").
                         __wlang_realign(col-1, true)
          [result, reached]
        end
  
    end # module YAML
  end # class RuleSet
end # module WLang
