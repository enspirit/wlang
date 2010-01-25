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
  # using instantiate. All other methods (parse, parse_block, has_block?) and the 
  # like are callbacks for rules and should not be used by users themselve.
  #
  # Obtaining a parser MUST be made through Parser.instantiator (new is private).
  #
  # == Detailed API
  class Parser

    # Factors a parser instance for a given template and an output buffer. 
    def self.instantiator(template, buffer=nil)
      Parser.send(:new, nil, template, nil, 0, buffer)
    end
  
    # Current parsed template
    attr_reader :template
    
    # Current source text
    attr_reader :source_text
  
    # Current offset
    attr_reader :offset
  
    # Current execution context
    attr_reader :context
  
    # Current buffer
    attr_reader :buffer
    
    # Current dialect
    attr_reader :dialect
    
    #
    # Initializes a parser instance. _parent_ is the Parser instance of the higher
    # parsing stage. _template_ is the current instantiated template, _offset_ is
    # where the parsing must start in the template and _buffer_ is the output buffer
    # where the instantiation result must be pushed.
    #
    def initialize(parent, template, dialect, offset, buffer)
      raise(ArgumentError, "Template is mandatory") unless WLang::Template===template
      raise(ArgumentError, "Offset is mandatory") unless Integer===offset
      dialect = template.dialect if dialect.nil?
      buffer = dialect.factor_buffer if buffer.nil?
      raise(ArgumentError, "Buffer is mandatory") unless buffer.respond_to?(:<<)
      @parent = parent
      @template = template
      @source_text = template.source_text
      @context = template.context
      @offset = offset
      @dialect = dialect
      @buffer = buffer
    end
    
    ###################################################################### Facade on wlang itself
    
    # Finds a real dialect instance from an argument (Dialect instance or 
    # qualified name)
    def ensure_dialect(dialect)
      if String===dialect
        dname, dialect = dialect, WLang::dialect(dialect)
        raise(ParseError,"Unknown modulation dialect: #{dname}") if dialect.nil?
      elsif not(Dialect===dialect)
        raise(ParseError,"Unknown modulation dialect: #{dialect}")
      end    
      dialect  
    end
    
    # Finds a real ecoder instance from an argument (Encoder instance or
    # qualified or unqualified name)
    def ensure_encoder(encoder)
      if String===encoder
        if encoder.include?("/")
          ename, encoder = encoder, WLang::encoder(encoder)
          raise(ParseError,"Unknown encoder: #{ename}") if encoder.nil?
        else
          ename, encoder = encoder, self.dialect.find_encoder(encoder)
          raise(ParseError,"Unknown encoder: #{ename}") if encoder.nil?
        end
      elsif not(Encoder===encoder)
        raise(ParseError,"Unknown encoder: #{encoder}")
      end
      encoder
    end
  
    ###################################################################### Main parser methods
  
    # Parses the template's text and instantiate it
    def instantiate
      # Main variables put in local scope for efficiency:
      #   - template:     current parsed template
      #   - source_text:  current template's source text
      #   - offset:       matching current position
      #   - pattern:      current dialect's regexp pattern
      #   - rules:        handlers of '{' currently opened
      template    = self.template
      source_text = self.source_text
      dialect     = self.dialect
      offset      = self.offset
      buffer      = self.buffer
      pattern     = dialect.pattern(template.block_symbols)
      rules       = []
    
      # we start matching everything in the ruleset
      while match_at=source_text.index(pattern,offset)
        match, match_length = $~[0], $~[0].length
      
        # puts pre_match (we can't use $~.pre_match !)
        self.<<(source_text[offset, match_at-offset], false) if match_at>0
      
        if source_text[match_at,1]=='\\'           # escaping sequence
          self.<<(match[1..-1], false)
          offset = match_at + match_length
        
        elsif match.length==1               # simple '{' or '}' here
          offset = match_at + match_length
          if match==Template::BLOCK_SYMBOLS[template.block_symbols][0]
            self.<<(match, false)  # simple '{' are always pushed
            # we push '{' in rules to recognize it's associated '}'
            # that must be pushed on buffer also
            rules << match   
          else
            # end of my job if I can't pop a previous rule
            break if rules.empty?
            # otherwise, push '}' only if associated to a simple '{'
            self.<<(match, false) unless Rule===rules.pop
          end
        
        elsif match[-1,1]==Template::BLOCK_SYMBOLS[template.block_symbols][0] # opening special tag
          # following line should never return nil as the matching pattern comes 
          # from the ruleset itself!
          rule = dialect.ruleset[match[0..-2]]     
          rules << rule
        
          # lauch that rule, get it's replacement and my new offset
          replacement, offset = rule.start_tag(self, match_at + match_length)
          replacement = "" if replacement.nil?
          raise "Bad implementation of rule #{match[0..-2]}" if offset.nil?
        
          # push replacement
          self.<<(replacement, true) unless replacement.empty?
        end
      
      end  # while match_at=...
    
      # trailing data (end of template reached only if no match_at)
      unless match_at
        unexpected_eof(source_text.length, '}') unless rules.empty?
        self.<<(source_text[offset, 1+source_text.length-offset], false)
        offset = source_text.length
      end
      [buffer, offset-1]
    end
  
    ###################################################################### Callbacks for rule sets
  
    #
    # Launches a child parser for instantiation at a given _offset_ in given 
    # _dialect_ (same dialect than self if dialect is nil) and with an output 
    # _buffer_.
    #
    def parse(offset, dialect=nil, buffer=nil)
      dialect = ensure_dialect(dialect.nil? ? self.dialect : dialect)
      Parser.send(:new, self, template, dialect, offset, buffer).instantiate 
    end
  
    # 
    # Checks if a given offset is a starting block. For easy implementation of rules
    # the check applied here is that text starting at _offset_ in the template is precisely
    # '}{' (the reason for that is that instantiate, parse, parse_block always stop 
    # parsing on a '}')
    #
    def has_block?(offset)
      self.source_text[offset,2]=='}{'
    end
  
    #
    # Parses a given block starting at a given _offset_, expressed in a given 
    # _dialect_ and using an output _buffer_. This method raises a ParseError if
    # there is no block at the offset. It implies that we are on a '}{', see 
    # has_block? for details. Rules may thus force mandatory block parsing without 
    # having to check anything. Optional blocks must be handled by rules themselve.
    #
    def parse_block(offset, dialect=nil, buffer=nil)
      block_missing_error(offset+2) unless has_block?(offset)
      parse(offset+2, dialect, buffer)
    end
  
    ###################################################################### Facade on the buffer
  
    # Appends on a given buffer
    def append_buffer(buffer, str, block)
      if buffer.respond_to?(:wlang_append)
        buffer.wlang_append(str, block)
      else
        buffer << str
      end
    end
  
    # Pushes a given string on the output buffer
    def <<(str, block)
      append_buffer(buffer, str, block)
    end

    ###################################################################### Facade on the scope
  
    #
    # Puts a key/value pair in the current context. See Parser::Context::define
    # for details.
    #
    def context_define(key, value)
      puts "Warning: using deprecated method Parser.context_define, #{caller[0]}"
      self.context.define(key,value)
    end

    #    
    # Pushes a new scope on the current context stack. See Parser::Context::push
    # for details.
    #
    def context_push(new_context)
      puts "Warning: using deprecated method Parser.context_push, #{caller[0]}"
      self.context.push(new_context)
    end

    #  
    # Pops the top scope of the context stack. See Parser::Context::pop for details.
    #
    def context_pop
      puts "Warning: using deprecated method Parser.context_pop, #{caller[0]}"
      self.context.pop
    end
  
    ###################################################################### Facade on the hosted language
  
    #
    # Evaluates a ruby expression on the current context. 
    # See WLang::Parser::Context#evaluate.
    #
    def evaluate(expression)
      context.evaluate(expression)
    rescue Exception => ex
      raise ::WLang::EvalError, "#{template.where(self.offset)} evaluation of '#{expression}' failed", ex.backtrace
    end
  
    ###################################################################### Facade on the dialect
  
    # Factors a specific buffer on the current dialect
    def factor_buffer
      self.dialect.factor_buffer
    end
    
    #
    # Encodes a given text using an encoder, that may be a qualified name or an
    # Encoder instance.
    #
    def encode(src, encoder, options=nil)
      options = {} unless options
      options['_encoder_'] = encoder
      options['_template_'] = template
      ensure_encoder(encoder).encode(src, options)
    end
  
    ###################################################################### About errors

    # Raises an exception with a friendly message
    def error(offset, message)
      template.error(offset, message)
    end
  
    #
    # Raises a ParseError at a given offset.
    #
    def syntax_error(offset, msg=nil)
      text = self.parse(offset, "wlang/dummy", "")
      msg = msg.nil? ? '' : ": #{msg}"
      template.parse_error(offset, "parse error on '#{text}'#{msg}")
    end
  
    #
    # Raises a ParseError at a given offset for a missing block
    #
    def block_missing_error(offset)
      template.parse_error(offset, "parse error, block was expected")
    end
  
    #
    # Raises a ParseError at a given offset for a unexpected EOF
    # specif. the expected character when EOF found
    #
    def unexpected_eof(offset, expected)
      template.parse_error(offset, "#{expected} expected, EOF found")
    end
  
    private_class_method :new
  end # class Parser

end # module WLang
