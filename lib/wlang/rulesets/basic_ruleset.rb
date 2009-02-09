#
# Basic ruleset, commonly included by any wlang dialect (but some tags, like
# <tt>${...}</tt> may be overriden). This ruleset is often installed conjointly
# with WLang::RuleSet::Encoding which provides interresting overridings of 
# <tt>${...}</tt> and <tt>+{...}</tt>. 
#
# For an overview of this ruleset, see the wlang {specification file}[link://files/specification.html].
#
module WLang::RuleSet::Basic
  
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {'!' => :execution, '%' => :modulation, '^' => :encoding,
                     '+' => :inclusion, '$' => :injection}
  
  # Rule implementation of <tt>!{wlang/ruby}</tt>.
  def self.execution(parser, offset)
    expression, reached = parser.parse(offset, "wlang/ruby")
    value = parser.evaluate(expression)
    result = value.nil? ? "" : value.to_s
    [result, reached]
  end
  
  # Rule implementation of <tt>%{wlang/active-string}{...}</tt>.
  def self.modulation(parser, offset)
    dialect, reached = parser.parse(offset, "wlang/active-string")
    result, reached = parser.parse_block(reached, dialect)
    [result, reached]
  end
  
  # Rule implementation of <tt>^{wlang/active-string}{...}</tt>
  def self.encoding(parser, offset)
    encoder, reached = parser.parse(offset, "wlang/active-string")
    result, reached = parser.parse_block(reached)
    result = parser.encode(result, encoder)
    [result, reached]
  end
    
  # Rule implementation of <tt>${wlang/ruby}</tt>
  def self.injection(parser, offset)
    execution(parser, offset)
  end
  
  # Rule implementation of <tt>+{wlang/ruby}</tt>
  def self.inclusion(parser, offset)
    execution(parser, offset)
  end
  
end  # module Basic