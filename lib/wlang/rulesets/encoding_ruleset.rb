module WLang
class RuleSet

#
# Implementation of the standard Encoding RuleSet
#
module Encoding
  
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {'&' => :main_encoding, '&;' => :entities_encoding, 
                     "&'" => :single_quoting, '&"' => :double_quoting,
                     "$" => :injection, "'" => :single_quoted, 
                     '"' => :double_quoted}
  
  # Main encoding as <tt>&{...}</tt>
  def self.main_encoding(parser, offset)
    parsed, reached = parser.parse(offset)
    result = parser.encode(parsed, "main-encoding")
    [result, reached]
  end
  
  # Entities-encoding as <tt>&;{...}</tt>
  def self.entities_encoding(parser, offset)
    parsed, reached = parser.parse(offset)
    result = parser.encode(parsed, "entities-encoding")
    [result, reached]
  end
  
  # Single-quoting as <tt>&'{...}</tt>
  def self.single_quoting(parser, offset)
    parsed, reached = parser.parse(offset)
    result = parser.encode(parsed, "single-quoting")
    [result, reached]
  end
  
  # Double-quoting as <tt>&"{...}</tt>
  def self.double_quoting(parser, offset)
    parsed, reached = parser.parse(offset)
    result = parser.encode(parsed, "double-quoting")
    [result, reached]
  end
  
  # Injection as <tt>${wlang/ruby}</tt>
  def self.injection(parser, offset)
    expression, reached = parser.parse(offset, "wlang/ruby")
    result = parser.evaluate(expression)
    encoded = parser.encode(result.to_s, "main-encoding")
    [encoded, reached]
  end
  
  # Single-quoted as <tt>'{wlang/ruby}</tt>
  def self.single_quoted(parser, offset)
    expression, reached = parser.parse(offset, "wlang/ruby")
    result = parser.evaluate(expression)
    encoded = parser.encode(result.to_s, "single-quoting")
    ["'" << encoded, reached]
  end
  
  # Double-quoted as <tt>"{wlang/ruby}</tt>
  def self.double_quoted(parser, offset)
    expression, reached = parser.parse(offset, "wlang/ruby")
    result = parser.evaluate(expression)
    encoded = parser.encode(result.to_s, "double-quoting")
    ['"' << encoded, reached]
  end
  
end # module Encoding
    
end # module RuleSet
end # module WLang