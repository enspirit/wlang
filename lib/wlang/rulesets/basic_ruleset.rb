#
# Basic ruleset, commonly included by any wlang dialect (but some tags, like
# <tt>${...}</tt> may be overriden). This ruleset is often installed conjointly
# with WLang::RuleSet::Encoding which provides interresting overridings of 
# <tt>${...}</tt> and <tt>+{...}</tt>. This ruleset provides the following tags 
# and associated rules:
#
# [!{wlang/ruby}] (*execution*) Instanciates #1, looking for a ruby expression. 
#                 Evaluates it, looking for any object. Invokes to_s on it and 
#                 returns the result as replacement value.
# [%{wlang/active-string}{...}] (*modulation*) Instanciates #1, looking for a dialect qualified 
#                               name. Instantiates #2 according to the rules defined 
#                               by that dialect and returns the #2's instantiation as 
#                               replacement value.
# [^{wlang/active-string}{...}] (*encoding*) Instanciates #1, looking for an encoder qualified name. 
#                               Instanciates #2 in the current dialect. 
#                               Encode #2's instantiation using encoder found in (#1) 
#                               and returns the encoded string as replacement value.
# [${wlang/ruby}]               (*injection*) Same semantics as execution so far.
# [+{wlang/ruby}]               (*inclusion*) Same semantics as execution so far.
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