require 'wlang/rule'
module WLang
  
#
# Set of recognition rules associated with a given dialect.
#
# This class allows grouping matching rules together to build a given dialect.
# Rules are always added with add_rule, which allows creating simple rules 
# on the fly (that is, without subclassing Rule).
#
# Examples:
#   # we will create a simple dialect with a special tag:
#   # - <tt>${...}</tt> which will uppercase its contents
#   simpledialect = RuleSet.new
#   simpledialect.add_rule '$' do |parser,offset|
#      content, offset = parser.parse_dummy
#      [content.upcase, offset] 
#   end 
#
# == Detailed API
class RuleSet

  #
  # Creates an new dialect rule set.
  #    
  def initialize() @rules, @pattern = {}, nil; end

  #  
  # Adds a tag matching rule. If rule is a String and a block is given, a new
  # Rule instance if created on the fly with _block_ as implementation 
  # (see Rule#new). Otherwise rule is expected to be a Rule instance. 
  # An ArgumentError is raised if arguments dont match one of these two cases. 
  #
  def add_rule(rule, &block) 
    if String===rule 
      raise(ArgumentError,"Block required") unless block_given?
      rule = Rule.new(rule, &block)
    end
    raise(ArgumentError, "Rule expected") unless Rule===rule
    @rules[rule.tag] = rule;  
    @pattern=nil; 
  end

  # Adds a really simple rule
  def add_text_rule(tag, &block)
    add_rule(tag) do |parser,offset|
      parsed, offset = parser.parse_dummy(offset, "")
      parsed = yield parsed
      [parsed, offset]
    end
  end
  
  #
  # Returns a Regexp instance with recognizes all tags installed in the rule set.
  # The returned Regexp is backslashing aware (it matches <tt>\${</tt> for example)
  # as well as '{' and '}' aware. This pattern is used by WLang::Parser and is
  # not intended to be used by users themselve.
  # 
  def pattern() @pattern ||= build_pattern; end

  #
  # Returns the Rule associated with a given tag, _nil_ if no such rule.
  #
  def [](tag) @rules[tag];  end
  
  ### protected section ######################################################
  protected
  
  # Internal implementation of pattern
  def build_pattern
    s = '([\\\\]{0,2}('
    i=0
    @rules.each_key do |tag|
      s << '|' if i>0
      s << '(' << Regexp.escape(tag) << ')'
      i += 1
    end
    s << ')\{)|[\\\\]{0,2}\{|[\\\\]{0,2}\}'
    Regexp.new(s)
  end
  
end # class RuleSet

end # module WLang