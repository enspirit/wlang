module WLang

#
# A WLang rule is designed to perform a replacement job when the special tag 
# associated with it is found in a template. Rules are always installed on a 
# RuleSet (using RuleSet#add_rule), which is itself installed as a dialect on 
# the wlang Parser (using Parser#add_dialect). Note that the methods mentionned
# both provides DRY shortcuts, allowing not using this class directly.
#  
# Example:
#    # Rule subclassing can be avoided by providing a block to new
#    # The following rule job is to upcase the text inside +{...} tags:
#    rule = Rule.new do |parser,offset,template|
#      parsed, offset = parser.parse_dummy(offset)
#      [parsed.upcase, offset]
#    end
#
# Creating a a new rule can be made in two ways: by subclassing this class and
# overriding the start_tag method or by passing a block to new. In both cases,
# <b>rules should always be stateless</b>, to allow reusable dialects that could
# even be used in a multi-threading environment. Implementing a rule correctly 
# must be considered non trivial due to the strong protocol between the parser 
# and its rules and the stateless convention. Always have a look to helpers 
# provided by RuleSet (to create simple rules easily) before deciding to implement
# a rule using this class.
#
# == Detailed API
class Rule

  #
  # Factory methods for commonly used rules 
  #
  class << self

    # Returns a reusable upcase rule. Content of the tag will be parsed with
    # the dummy dialect and returned upcased.
    def UPCASE() 
      @upcase ||= Rule.new do |parser,offset|
        parsed, offset = parser.parse_dummy(offset)
        [parsed.upcase, offset]
      end
    end
        
    # Returns a reusable downcase rule. Content of the tag will be parsed with
    # the dummy dialect and returned downcased.
    def DOWNCASE() 
      @downcase ||= Rule.new do |parser,offset|
        parsed, offset = parser.parse_dummy(offset)
        [parsed.downcase, offset]
      end
    end
        
    # Returns a reusable backquote rule. Content of the tag will be parsed with
    # the dummy dialect. Simple quotes will be replaced by \' 
    def BACKQUOTE() 
      @backquote ||= Rule.new do |parser,offset|
        parsed, offset = parser.parse_dummy(offset)
        [parsed.gsub("'","\\\\'"), offset]
      end
    end
        
    # Returns a reusable backdoublequote rule. Content of the tag will be parsed 
    # with the dummy dialect. Double quotes will be replaced by \" 
    def BACKDOUBLEQUOTE() 
      @backdoublequote ||= Rule.new do |parser,offset|
        parsed, offset = parser.parse_dummy(offset)
        [parsed.gsub('"','\"'), offset]
      end
    end
        
  end
    
  #
  # Creates a new rule, associated to _tag_. If no block is given, the invocation
  # of new MUST be made on a subclass overriding start_tag. Otherwise, the block
  # is considered as the effective implementation of start_tag and will be called
  # with the same arguments. 
  #
  def initialize(&block) 
    @block = block 
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
  # - parser: WLang parser currently parsing the text.
  # - offset: offset reached in the text, corresponding to the first character
  #   of the first block associated with the matching tag.
  # - template: template being instanciated
  #
  def start_tag(parser, offset, template)
    raise NotImplementedError unless @block
    @block.call(parser, offset, template)
  end

end # class Rule

end # module WLang