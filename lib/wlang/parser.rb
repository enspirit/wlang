require 'stringio'
require 'wlang/rule'
require 'wlang/rule_set'
require 'wlang/errors'
require 'wlang/template'
module WLang

  #
  # Parser for wlang templates.
  #
  # This class implements the parsing algorithm of wlang, recognizing special tags
  # and replacing them using installed rules. Instanciating a template is done 
  # using instanciate. All other methods (parse, parse_block, has_block?) and the 
  # like are callbacks for rules and should not be used by users themselve.
  #
  # Obtaining a parser MUST be made through Parser.instantiator (new is private).
  #
  # == Detailed API
  class Parser

    # Factors a parser instance for a given template and an output buffer. 
    def self.instantiator(template, buffer="")
      Parser.send(:new, nil, template, nil, 0, buffer)
    end
  
    # Current parsed template
    attr_reader :template
  
    # Current execution context
    attr_reader :context
  
    # Current buffer
    attr_reader :buffer
  
    #
    # Initializes a parser instance. _parent_ is the Parser instance of the higher
    # parsing stage. _template_ is the current instantiated template, _offset_ is
    # where the parsing must start in the template and _buffer_ is the output buffer
    # where the instantiation result must be pushed.
    #
    def initialize(parent, template, dialect, offset, buffer)
      raise(ArgumentError, "Template is mandatory") unless WLang::Template===template
      raise(ArgumentError, "Offset is mandatory") unless Integer===offset
      raise(ArgumentError, "Buffer is mandatory") unless buffer.respond_to?(:<<)
      dialect = template.dialect if dialect.nil?
      @parent = parent
      @template = template
      @context = template.context
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
      offset, pattern, rules = @offset, @dialect.pattern(@template.block_symbols), []
      @source_text = template.source_text
    
      # we start matching everything in the ruleset
      while match_at=@source_text.index(pattern,offset)
        match, match_length = $~[0], $~[0].length
      
        # puts pre_match (we can't use $~.pre_match !)
        self.<<(@source_text[offset, match_at-offset]) if match_at>0
      
        if @source_text[match_at,1]=='\\'           # escaping sequence
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
          replacement = "" if replacement.nil?
          raise "Bad implementation of rule #{match[0..-2]}" if offset.nil?
        
          # push replacement
          self.<<(replacement) unless replacement.empty?
        end
      
      end  # while match_at=...
    
      # trailing data (end of @template reached only if no match_at)
      unless match_at
        unexpected_eof(@source_text.length, '}') unless rules.empty?
        self.<<(@source_text[offset, 1+@source_text.length-offset])
        offset = @source_text.length
      end
      [@buffer, offset-1]
    end
  
    #
    # Evaluates a ruby expression on the current context. 
    # See WLang::Parser::Context#evaluate.
    #
    def evaluate(expression)
      @context.evaluate(expression)
    end
  
    #
    # Launches a child parser for instantiation at a given _offset_ in given 
    # _dialect_ (same dialect than self if dialect is nil) and with an output 
    # _buffer_.
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
      Parser.send(:new, self, @template, dialect, offset, buffer).instantiate 
    end
  
    # 
    # Checks if a given offset is a starting block. For easy implementation of rules
    # the check applied here is that text starting at _offset_ in the template is precisely
    # '}{' (the reason for that is that instantiate, parse, parse_block always stop 
    # parsing on a '}')
    #
    def has_block?(offset)
      @source_text[offset,2]=='}{'
    end
  
    #
    # Parses a given block starting at a given _offset_, expressed in a given 
    # _dialect_ and using an output _buffer_. This method raises a ParseError if
    # there is no block at the offset. It implies that we are on a '}{', see 
    # has_block? for details. Rules may thus force mandatory block parsing without 
    # having to check anything. Optional blocks must be handled by rules themselve.
    #
    def parse_block(offset, dialect=nil, buffer="")
      block_missing_error(offset+2) unless has_block?(offset)
      parse(offset+2, dialect, buffer)
    end
  
    #
    # Encodes a given text using an encoder, that may be a qualified name or an
    # Encoder instance.
    #
    def encode(src, encoder, options=nil)
      options = {} unless options
      options['_encoder_'] = encoder
      if String===encoder
        if encoder.include?("/")
          ename, encoder = encoder, WLang::encoder(encoder)
          raise(ParseError,"Unknown encoder: #{ename}") if encoder.nil?
        else
          ename, encoder = encoder, @dialect.find_encoder(encoder)
          raise(ParseError,"Unknown encoder: #{ename}") if encoder.nil?
        end
      elsif not(Encoder===encoder)
        raise(ParseError,"Unknown encoder: #{encoder}")
      end
      encoder.encode(src, options)
    end
  
    #
    # Raises a ParseError at a given offset.
    #
    def syntax_error(offset)
      text = self.parse(offset, "wlang/dummy", "")
      raise ParseError, "Parse error at #{offset} on '#{text}'"
    end
  
    #
    # Raises a ParseError at a given offset for a missing block
    #
    def block_missing_error(offset)
      raise ParseError.new("Block expected", offset, @source_text)
    end
  
    #
    # Raises a ParseError at a given offset for a unexpected EOF
    # specif. the expected character when EOF found
    #
    def unexpected_eof(offset, expected)
      raise ParseError.new("'#{expected}' expected, EOF found.", offset, @source_text)
    end
  
    #
    # Puts a key/value pair in the current context. See Parser::Context::define
    # for details.
    #
    def context_define(key, value)
      @context.define(key,value)
    end

    #    
    # Pushes a new scope on the current context stack. See Parser::Context::push
    # for details.
    #
    def context_push(context)
      @context.push(context)
    end

    #  
    # Pops the top scope of the context stack. See Parser::Context::pop for details.
    #
    def context_pop
      @context.pop
    end
  
    private_class_method :new
  end # class Parser

end # module WLang
