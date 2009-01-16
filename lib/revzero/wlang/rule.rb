module WLang

#
# Tag recognition rule.
#
# A WLang rule is designed to perform a given job when the special tag associated
# with it is found in the text. Rules are always installed on a RuleSet (using 
# RuleSet#add_rule), which is the set of rules associated with a given dialect. 
# Creating a a new rule can be made in two ways: 1) by subclassing this class and
# overriding the start_tag method or by passing a block to new.
#
# == Detailed API
class Rule
  attr_reader :tag
  
  #
  # Creates a new rule, associated to _tag_. If no block is given, the invocation
  # of new MUST be made on a subclass overriding start_tag. Otherwise, the block
  # is considered as the effective implementation of start_tag and will be called
  # with the same arguments. 
  #
  def initialize(tag, &block) 
    @tag, @block = tag, block 
  end
  
  #
  # Fired when the parser has reached an offset matching this rule.
  #
  # This method MUST return an array [_replacement_, _offset_] where _replacement_ 
  # is what replaces the tag itself in the resulting text and _offset_ is the 
  # new offset reached in the source text (where parsing will continue). 
  # _offset_ should always be such that <tt>text[offset,1]=='}'</tt> to allow
  # higher stages to continue their job correctly. Utility methods for parsing 
  # text parts are provided by the parser itself (see WLang::Parser).
  #
  # Arguments:
  # - parser: WLang parser currently parsing the text
  # - offset: offset reached in the text, corresponding to the first character
  #   of the first block associated with the matching tag.
  # - template: template being instanciated
  #
  def start_tag(parser, offset, template)
    raise NotImplementedError unless @block
    @block.call(parser, offset, template)
  end

  # Returns string representation (for debuging purposes)
  def to_s() @tag + '{...}' end

  # Returns string representation (for debuging purposes)
  def inspect() @tag + '{...}' end
      
end # class Rule

end # module WLang