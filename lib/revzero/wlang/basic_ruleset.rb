module WLang
class RuleSet
  
  # Basic ruleset
  module Basic
    
    # Default mapping between tag symbols and methods
    DEFAULT_RULESET = {'!' => :execution, '%' => :modulation, '^' => :encoding,
                       '+' => :inclusion, '$' => :injection}
    
    #
    # Execution as <tt>!{wlang/hosted}</tt>
    #
    # Instanciates #1, looking for an expression in the hosting language. 
    # Evaluates it, looking for any object. Invokes to_s on it and returns the 
    # result.
    #
    def self.execution(parser, offset)
      expression, reached = parser.parse(offset, "wlang/ruby")
      value = parser.evaluate(expression)
      result = value.nil? ? "" : value.to_s
      [result, reached]
    end
    
    #
    # Language modulation as <tt>%{wlang/hosted}{...}</tt>.
    #
    # Instanciates #1, looking for a wlang language name. Instantiates #2 
    # according to the rules defined by that language (#1) and returns the 
    # result.
    #
    def self.modulation(parser, offset)
      dialect, reached = parser.parse(offset, "wlang/active-string")
      result, reached = parser.parse_block(reached, dialect)
      [result, reached]
    end
    
    #
    # Encoding as <tt>^{wlang/actstring}{...}</tt>
    #
    # Instanciates #1, looking for an encoder name. Instanciates #2 in the 
    # current wlang language, passes result to the found encoder (#1) and 
    # returns the encoded string.
    # 
    def self.encoding(parser, offset)
      encoder, reached = parser.parse(offset, "wlang/active-string")
      result, reached = parser.parse_block(reached)
      result = parser.encode(text, encoder)
      [result, reached]
    end
      
    # 
    # Inclusion as <tt>+{wlang/hosted}</tt>
    #
    # By default, has same semantics as execution.
    #
    def self.inclusion(parser, offset)
      execution(parser, offset)
    end
    
    # 
    # Injection as <tt>${wlang/hosted}</tt>
    #
    # By default, has same semantics as execution.
    #
    def self.injection(parser, offset)
      execution(parser, offset)
    end
    
  end  # module Basic
  
end # class RuleSet
end # module WLang