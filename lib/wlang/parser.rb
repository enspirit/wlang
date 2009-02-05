require 'stringio'
require 'wlang/rule'
require 'wlang/rule_set'
require 'wlang/errors'
require 'wlang/parser_context'
module WLang

#
# Parser for wlang templates.
#
# This class implements the parsing algorithm of wlang, recognizing special tags
# and replacing them using installed rules. Dialects can be installed using 
# add_dialect. Instanciating a template is done using instanciate. Methods parse 
# and parse_xxx are callbacks for rules and should be be used by users themselve.
#
# Examples (less trivial examples can be found in the examples/ directory): 
#   # we will create a simple dialect with two simple tags:
#   #   +{...} will uppercase its contents
#   #   -{...} will downcase its contents
#   parser = WLang::Parser.new
#   parser.add_dialect(:simple) do
#     add_text_rule '+' { |text| text.upcase   }
#     add_text_rule '-' { |text| text.downcase }
#   end
#   parser.instanciate('-{HELLO} +{world}')   # prints 'hello WORLD'
#
# == Detailed API
class Parser

  # Factors an instantiator
  def self.instantiator(template, dialect, context={}, buffer="")
    Parser.new(nil, Parser::Context.new(context), template, 0, dialect, buffer)
  end
  
  # Current parsed template
  attr_reader :template
  
  # Initializes a parser element
  def initialize(parent, context, template, offset, dialect, buffer)
    raise(ArgumentError, "Template is mandatory") if template.nil?
    raise(ArgumentError, "Offset is mandatory") if offset.nil?
    raise(ArgumentError, "Dialect is mandatory") if dialect.nil?
    raise(ArgumentError, "Buffer is mandatory") if buffer.nil?
    if String===dialect
      dname, dialect = dialect, WLang::dialect(dialect)
      raise(ArgumentError,"Unknown dialect #{dname}") if dialect.nil?
    end
    @parent = parent
    @context = context
    @template = template
    @offset = offset
    @dialect = dialect
    @buffer = buffer
  end
  
  # Pushes a given string on the output buffer
  def <<(str)
    @buffer << str
  end

  # Parses the text
  def instantiate
    # Main variables:
    # - offset: matching current position
    # - rules: handlers of '{' currently opened
    offset, pattern, rules = @offset, @dialect.pattern, []
    
    # we start matching everything in the ruleset
    while match_at=@template.index(pattern,offset)
      match, match_length = $~[0], $~[0].length
      
      # puts pre_match (we can't use $~.pre_match !)
      self.<<(@template[offset, match_at-offset]) if match_at>0
      
      if @template[match_at,1]=='\\'           # escaping sequence
        self.<<(match[1..-1])
        offset = match_at + match_length
        
      elsif match.length==1               # simple '{' or '}' here
        offset = match_at + match_length
        if match=='{'
          self.<<(match)  # simple '{' are always pushed
          # we push '{' in rules to recognize it's associated '}'
          # that must be pushed on buffer also
          rules << match   
        else
          # end of my job if I can't pop a previous rule
          break if rules.empty?
          # otherwise, push '}' only if associated to a simple '{'
          self.<<(match) unless Rule===rules.pop
        end
        
      elsif match[-1,1]=='{'              # opening special tag
        # following line should never return nil as the matching pattern comes 
        # from the ruleset itself!
        rule = @dialect.ruleset[match[0..-2]]     
        rules << rule
        
        # lauch that rule, get it's replacement and my new offset
        replacement, offset = rule.start_tag(self, match_at + match_length)
        
        # push replacement
        self.<<(replacement) unless replacement.empty?
      end
      
    end  # while match_at=...
    
    # trailing data (end of @template reached only if no match_at)
    unless match_at
      raise(ParseError, "ParseError at #{offset}, '}' expected, EOF found.")\
        unless rules.empty?
      self.<<(@template[offset, 1+@template.length-offset])
      offset = @template.length
    end
    [@buffer, offset-1]
  end
  
  #
  # Evaluates a ruby expression on the current context.
  #
  def evaluate(expression)
    @context.evaluate(expression)
  end
  
  #
  # Lauches a child parser at a given offset for a given dialect (same dialect
  # than self if dialect is nil).
  #
  def parse(offset, dialect=nil, buffer="")
    if dialect.nil?
      dialect = @dialect
    elsif String===dialect
      dname, dialect = dialect, WLang::dialect(dialect)
      raise(ParseError,"Unknown modulation dialect: #{dname}") if dialect.nil?
    elsif not(Dialect===dialect)
      raise(ParseError,"Unknown modulation dialect: #{dialect}")
    end
    Parser.new(self, @context, @template, offset, dialect, buffer).instantiate 
  end
    
  # Checks if a given offset is a block
  def has_block?(offset)
    @template[offset,2]=='}{'
  end
  
  # Parses a given block
  def parse_block(offset, dialect=nil, buffer="")
    raise(ParseError,"Block expected at #{offset}") unless has_block?(offset)
    parse(offset+2, dialect, buffer)
  end
  
  # Encodes a given text using an encoder
  def encode(src, encoder, options=nil)
    if String===encoder
      if encoder.include?("/")
        ename, encoder = encoder, WLang::encoder(encoder)
        raise(ParseError,"Unknown encoder: #{ename}") if encoder.nil?
      else
        ename, encoder = encoder, @dialect.find_encoder(encoder)
        raise(ParseError,"Unknown encoder: #{ename}") if encoder.nil?
      end
    elsif not(Proc===encoder)
      raise(ParseError,"Unknown encoder: #{encoder}")
    end
    encoder.call(src, options)
  end
  
end # class Parser
end # module WLang
