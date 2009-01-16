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
    
  #
  # Creates an parser instance.
  #
  # If _dialect_ is specified, it will be considered as the default dialect of
  # the parser. Otherwise, the first one installed using add_dialect will be
  # considered so. 
  #
  def initialize(dialect=nil)
    raise(ArgumentError, "Symbol expected for dialect, #{dialect} received")\
      unless dialect.nil? or Symbol===dialect
    @dialects, @dialect, @stack, @source = {}, dialect, nil, nil
    add_dialect(:dummy, DUMMY_RULESET)
  end

  #
  # Adds a new dialect to the parser. 
  #
  # _dialect_ is required to be a Symbol instance. If specified, _ruleset_ must 
  # be a RuleSet instance. If ommitted, an empty RuleSet will be created. If a 
  # block is provided, it is executed by passing the _ruleset_ (or the newly
  # created one) as block argument. This allows creating and installing dialects
  # on the fly:
  #
  #    parser = WLang::Parser.new
  #    parser.add_dialect(:simple) do |s|
  #      s.add_text_rule '+' {|text| text.upcase   }
  #      s.add_text_rule '-' {|text| text.downcase } 
  #    end
  # 
  # If no default dialect has been installed at construction and it is the 
  # first user invocation of the method, _dialect_ will be installed as the 
  # default parser dialect. This method checks it's arguments and raises an
  # ArgumentError if not valid.
  #
  def add_dialect(dialect, ruleset=nil)
    raise(ArgumentError, "Symbol expected for dialect, #{dialect} received")\
      unless Symbol===dialect
    raise(ArgumentError, "RuleSet expected for ruleset, #{ruleset} received")\
      unless ruleset.nil? or RuleSet===ruleset
    if @dialects.size==1 then @dialect=dialect end
    ruleset = RuleSet.new unless ruleset
    @dialects[dialect] = ruleset
    yield ruleset if block_given?
  end

  #  
  # Lauches a parsing sub-session, using rules installed under _dialect_, 
  # starting at _offset_ in the source template and using _buffer_ for 
  # instanciation.
  # 
  # _dialect_ must be a Symbol instance and must be a known dialect for the 
  # parser (previously installed with add_dialect). _offset_ must be an Integer.
  # _buffer_ may be any object responding to <tt><<</tt>. This method checks
  # its arguments and raises an ArgumentError when not valid.  
  #
  # Moreover, this method is provided as a callback for rules. It is not 
  # intended to be used by users themselve and raises a ParseError if there is
  # no enclosing call to instanciate.
  #
  def parse(dialect, offset, buffer="")
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

  #
  # Lauches a parsing sub-session on the dummy dialect.
  #
  # The dummy dialect is always installed on the parser and contains no rule
  # at all. Parsed text is guaranteed to be all template text between offset
  # and the next non backslashed real occurence of '}' (by real, we mean that 
  # '{' and '}' pairs are parsed without stopping on the last. 
  #
  # Moreover, this method is provided as a callback for rules. It is not 
  # intended to be used by users themselve and raises a ParseError if there is
  # no enclosing call to instanciate.
  #
  def parse_dummy(offset, buffer="") parse(:dummy, offset, buffer) end
  
  #
  # Instanciates a given template, writing instanciation on a specified _buffer_
  # (STDOUT by default). _template_ must be a String instance; _buffer_ is any
  # object responding to <tt><<</tt>. If _dialect_ is specified, it is the 
  # parsing dialect that will be used; otherwise the default parser dialect is
  # used. This method returns the buffer.
  #
  # This method checks its arguments and raises an ArgumentError if incorrect.
  # It raises a ParseError if the template does not respect the wlang abstract 
  # grammar. It can also raise an ArgumentError if an installed dialect rule
  # is not correctly implemented. 
  #
  def instanciate(template, buffer=STDOUT, dialect=nil)
    raise(ArgumentError,"String expected for template") unless String===template
    raise(ArgumentError,"Object.<< expected for buffer") unless buffer.respond_to?(:<<)    
    raise(ArgumentError, "Symbol expected for dialect.") unless dialect==nil or Symbol===dialect
    raise(ArgumentError, "No dialect previously installed") if dialect.nil? and @dialect.nil?
    @source, @stack = template, []
    buf,offset = parse(dialect ? dialect : @dialect, 0, buffer)
    raise(ParseError,"Parse error at #{offset}: EOF expected, #{template[offset,1]} found.")\
      unless offset==template.length-1
    @source, @stack = nil, nil
    buffer
  end
      
end # class Parser

end # module WLang
