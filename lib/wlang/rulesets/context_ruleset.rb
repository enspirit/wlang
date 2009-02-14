require 'wlang/rulesets/ruleset_utils'

#
# Provides a ruleset for managing the context/scoping during instantitation.
#
# For an overview of this ruleset, see the wlang {specification file}[link://files/specification.html].
#
module WLang::RuleSet::Context
  U=WLang::RuleSet::Utils
  
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {'=' => :assignment, '%=' => :modulo_assignment}

  # Rule implementation of <tt>={wlang/hosted as x}{...}</tt>
  def self.assignment(parser, offset)
    expr, reached = parser.parse(offset, "wlang/ruby")
    
    # decode expression
    decoded = U.decode_expr_as(expr)
    parser.syntax_error(offset) if decoded.nil?
    
    # evaluate it
    value = parser.evaluate(decoded[:expr])
    
    # handle two different cases
    if parser.has_block?(reached)
      parser.context_push(decoded[:variable] => value)
      text, reached = parser.parse_block(reached)
      parser.context_pop
      [text, reached]
    else
      parser.context_define(decoded[:variable], value)
      ["", reached]
    end
  end
    
  # Rule implementation of <tt>%={wlang/active-string as x}{...}{...}</tt>
  def self.modulo_assignment(parser, offset)
    dialect_as, reached = parser.parse(offset, "wlang/ruby")

    # decode expression
    decoded = U.decode_qdialect_as(dialect_as)
    if decoded.nil?
      decoded = U.decode_var(dialect_as)
      parser.syntax_error(offset) if decoded.nil?
      decoded[:dialect] = nil
    end
    
    # parse second block in that dialect
    value, reached = parser.parse_block(reached, decoded[:dialect])
    
    # handle two different cases
    if parser.has_block?(reached)
      parser.context_push(decoded[:variable] => value)
      text, reached = parser.parse_block(reached)
      parser.context_pop
      [text, reached]
    else
      parser.context_define(decoded[:variable], value)
      ["", reached]
    end
  end
    
end