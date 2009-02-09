#
# Provides a ruleset for managing the context/scoping during instantitation.
#
# For an overview of this ruleset, see the wlang {specification file}[link://files/specification.html].
#
module WLang::RuleSet::Context
  
  # Define regular expression
  DEFINE_REGEXP = /^(\s*(.*?)\s+as\s+([-a-z_]+)\s*)|(\s*([-a-z_]+)\s*)$/
  #                 1   2            3              4   5
  
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {'=' => :local, '.=' => :define}

  # Decodes a define expression like 'items as i'
  def self.decode_define(src)
    return nil unless match=DEFINE_REGEXP.match(src)
    if match[2]
      {:expression => match[2], :name => match[3]}
    else
      {:expression => nil, :name => match[5]}
    end
  end
      
  # Rule implementation of <tt>.={wlang/ruby}{...}</tt>
  def self.define(parser, offset)
    expr, reached = parser.parse(offset, "wlang/ruby")
    decoded = decode_define(expr)
    parser.syntax_error(offset) if decoded.nil?
    if decoded[:expression].nil?
      # .={name}{...}
      text, reached = parser.parse_block(reached)
      parser.context_define(decoded[:name], text)
      ["", reached]
    else
      # .={expr as name}
      value = parser.evaluate(decoded[:expression])
      parser.context_define(decoded[:name], value)
      ["", reached]
    end
  end
    
  # Rule implementation of <tt>={wlang/ruby}{...}</tt>
  def self.local(parser, offset)
    
  end
    
      
end