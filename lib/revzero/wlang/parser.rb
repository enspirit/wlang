require 'stringio'
require 'wlang/rule'
require 'wlang/rule_set'
require 'wlang/errors'
module WLang

#
# Parser for wlang templates.
#
# This class implements the parsing algorithm of wlang, recognizing special tags
# and replacing them using installed rules. Dialects can be installed using 
# add_dialect. Instanciating a template is done using instanciate.
#
# Examples (more complete example can be found in the examples/ directory): 
#   # we will create a simple dialect with a special tag:
#   # - <tt>${...}</tt> which will uppercase its contents
#   simpledialect = WLang::RuleSet.new
#   simpledialect.add_rule '$' do |parser,offset|
#      content, offset = parser.parse_dummy
#      [content.upcase, offset] 
#   end
#   parser = WLang::Parser.new.add_dialect(:simple, simpledialect)
#   parser.instanciate('hello ${world}')   # prints 'hello WORLD'
#
# == Detailed API
class Parser

  # A dummy rule set, parsing text as itself
  DUMMY_RULESET = RuleSet.new
    
  # Call stack element
  class ParserState
    attr_reader :offset, :ruleset, :rule, :buffer 
    
    # Initializes a stack element with an active tag set and buffer
    def initialize(offset, ruleset, buffer)
      @offset, @ruleset, @buffer = offset, ruleset, buffer
    end
    
    # Pushes a given string on the output buffer
    def <<(str)
      #puts "Pushing |#{str}| on #{@buffer.class}"
      @buffer << str
    end

    # Returns the current pattern in use 
    def pattern() @ruleset.pattern end
        
    # Parses the text
    def parse(parser, text)
      # Main variables:
      # - offset: matching current position
      # - rules: handlers of '{' currently opened
      offset, rules = @offset, []
      
      # we start matching everything in the ruleset
      while match_at=text.index(pattern,offset)
        match, match_length = $~[0], $~[0].length
        
        # puts pre_match (we can't use $~.pre_match !)
        self.<<(text[offset, match_at-offset]) if match_at>0
        
        if text[match_at,1]=='\\'           # escaping sequence
          self.<<(match[1..-1])
          offset = match_at + match_length
          
        elsif match.length==1               # simple '{' or '}' here
          offset = match_at + match_length
          if match=='{'
            #puts "\nMatching { when #{rules.inspect}" if @offset==0
            self.<<(match)  # simple '{' are always pushed
            # we push '{' in rules to recognize it's associated '}'
            # that must be pushed on buffer also
            rules << match   
            #puts "[{] Now rules are #{rules.inspect}" if @offset==0
          else
            #puts "\nMatching } when #{rules.inspect}" if @offset==0
            # end of my job if I can't pop a previous rule
            break if rules.empty?
            # otherwise, push '}' only if associated to a simple '{'
            self.<<(match) unless Rule===rules.pop
            #puts "[}] Now rules are #{rules.inspect}" if @offset==0
          end
          
        elsif match[-1,1]=='{'              # opening special tag
          #puts "\nMatching ..{ when #{rules.inspect}" if @offset==0
          # following line should never return nil as the matching pattern comes 
          # from the ruleset itself!
          rule = @ruleset[match[0..-2]]     
          rules << rule
          
          # lauch that rule, get it's replacement and my new offset
          replacement, offset = rule.start_tag(parser, match_at + match_length, text)
          
          #puts "[..{] Now, rules are #{rules.inspect}" if @offset==0
          # push replacement
          self.<<(replacement) unless replacement.empty?
        end
        
      end  # while match_at=...
      
      # trailing data (end of text reached only if no match_at)
      unless match_at
        raise(ParseError, "ParseError at #{offset}, '}' expected, EOF found.@buffer #{rules.inspect}")\
          unless rules.empty?
        self.<<(text[offset, 1+text.length-offset])
        offset = text.length
      end
      [@buffer, offset-1]
    end
      
  end # class ParserState
    
  # Creates an parser instance with a given ruleset
  def initialize(dialect)
    raise(ArgumentError, "Symbol expected for dialect, #{dialect} received")\
      unless Symbol===dialect
    @dialects, @dialect, @stack, @source = {}, dialect, nil, nil
    add_dialect(:dummy, DUMMY_RULESET)
  end

  # Adds a rule set for a given dialect
  def add_dialect(dialect, ruleset)
    raise(ArgumentError, "Symbol expected for dialect, #{dialect} received")\
      unless Symbol===dialect
    raise(ArgumentError, "RuleSet expected for ruleset, #{ruleset} received")\
      unless RuleSet===ruleset
    @dialects[dialect] = ruleset
  end
  
  # Parses some text
  def parse(dialect, offset, buffer)
    raise(ArgumentError,"Symbol expected for dialect") unless Symbol===dialect
    raise(ArgumentError, "No such dialect #{dialect}") unless @dialects.has_key?(dialect)
    raise(ArgumentError,"Integer expected for offset") unless Integer===offset    
    raise(ArgumentError,"Object.<< expected for buffer") unless buffer.respond_to?(:<<)    
    raise(ParseError,"Illegal state, no source installed") unless @source
    @stack << ParserState.new(offset,@dialects[dialect],buffer)
    buffer_and_offset = @stack[-1].parse(self,@source)
    @stack.pop
    buffer_and_offset
  end

  # Parses dummy dialect
  def parse_dummy(offset, buffer) parse(:dummy, offset, buffer) end
  
  #
  # Instanciates a given template, writing instanciation on _buffer_, which is
  # expected to be any instance responding to <tt><<</tt>. Returns the buffer
  # itself.
  #
  def instanciate(template, buffer=STDOUT)
    raise(ArgumentError,"String expected for template") unless String===template
    raise(ArgumentError,"Object.<< expected for buffer") unless buffer.respond_to?(:<<)    
    @source, @stack = template, []
    buf,offset = parse(@dialect, 0, buffer)
    raise(ParseError,"Parse error at #{offset}: EOF expected, #{template[offset,1]} found.")\
      unless offset==template.length-1
    @source, @stack = nil, nil
    buffer
  end
      
end # class Parser

end # module WLang
