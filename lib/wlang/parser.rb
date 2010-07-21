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
  # == Detailed API
  class Parser

    # Initializes a parser instance.
    def initialize(hosted, template, scope)
      raise(ArgumentError, "Hosted language is mandatory (a ::WLang::HostedLanguage)") unless ::WLang::HostedLanguage===hosted
      raise(ArgumentError, "Template is mandatory (a ::WLang::Template)") unless ::WLang::Template===template
      raise(ArgumentError, "Scope is mandatory (a Hash)") unless ::Hash===scope
      @state = ::WLang::Parser::State.new(self).branch(
        :hosted   => hosted,
        :template => template,
        :dialect  => template.dialect,
        :offset   => 0,
        :shared   => :none,
        :scope    => scope,
        :buffer   => template.dialect.factor_buffer)
    end
    
    ###################################################################### Facade on the parser state
    
    # Returns the current parser state
    def state(); @state; end
    
    # Returns the current template
    def template() state.template; end
    
    # Returns the current buffer
    def dialect() state.dialect; end
    
    # Returns the current template's source text
    def source_text() state.template.source_text; end
    
    # Returns the current offset
    def offset() state.offset; end

    # Sets the current offset of the parser    
    def offset=(offset) state.offset = offset; end
    
    # Returns the current buffer
    def buffer() state.buffer; end
    
    # Returns the current hosted language
    def hosted() state.hosted; end
    
    # Branches the current parser
    def branch(opts = {}) 
      raise ArgumentError, "Parser branching requires a block" unless block_given?
      @state = @state.branch(opts)
      result = yield(@state)
      @state = @state.parent
      result
    end
    
    ###################################################################### Facade on the file system
    
    # Resolves an URI throught the current template
    def file_resolve(uri)
      template.file_resolve(uri)
    end
    
    ###################################################################### Facade on wlang itself
    
    # Factors a template instance for a given file
    def file_template(file, dialect = nil, block_symbols = :braces)
      WLang::file_template(file, dialect, block_symbols)
    end
    
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
    
    # Checks the result of a given rule
    def launch_rule(dialect, rule_symbol, rule, offset)
      result = rule.start_tag(self, offset)
      raise WLang::Error, "Bad rule implementation #{dialect.qualified_name} #{rule_symbol}{}\n#{result.inspect}"\
        unless result.size == 2 and String===result[0] and Integer===result[1]
      result
    end
  
    # Parses the template's text and instantiate it
    def instantiate
      # Main variables put in local scope for efficiency:
      #   - template:     current parsed template
      #   - source_text:  current template's source text
      #   - offset:       matching current position
      #   - pattern:      current dialect's regexp pattern
      #   - rules:        handlers of '{' currently opened
      template    = self.template
      symbols     = self.template.block_symbols
      source_text = self.source_text
      dialect     = self.dialect
      buffer      = self.buffer
      pattern     = dialect.pattern(template.block_symbols)
      rules       = []
    
      # we start matching everything in the ruleset
      while match_at=source_text.index(pattern, self.offset)
        match, match_length = $~[0], $~[0].length
      
        # puts pre_match (we can't use $~.pre_match !)
        self.<<(source_text[self.offset, match_at-self.offset], false) if match_at>0
      
        if source_text[match_at,1]=='\\'           # escaping sequence
          self.<<(match[1..-1], false)
          self.offset = match_at + match_length
        
        elsif match.length==1               # simple '{' or '}' here
          self.offset = match_at + match_length
          if match==Template::BLOCK_SYMBOLS[symbols][0]
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
        
        elsif match[-1,1]==Template::BLOCK_SYMBOLS[symbols][0] # opening special tag
          # following line should never return nil as the matching pattern comes 
          # from the ruleset itself!
          rule_symbol = match[0..-2]
          rule = dialect.ruleset[rule_symbol]     
          rules << rule
        
          # Just added to get the last position in case of an error
          self.offset = match_at + match_length

          # lauch that rule, get it's replacement and my new offset
          replacement, self.offset = launch_rule(dialect, rule_symbol, rule, self.offset)
      
          # push replacement
          self.<<(replacement, true) unless replacement.empty?
        end
      
      end  # while match_at=...
    
      # trailing data (end of template reached only if no match_at)
      unless match_at
        unexpected_eof(source_text.length, '}') unless rules.empty?
        self.<<(source_text[self.offset, 1+source_text.length-self.offset], false)
        self.offset = source_text.length
      end
      [dialect.apply_post_transform(buffer), self.offset-1]
    end
  
    ###################################################################### Callbacks for rule sets
  
    #
    # Launches a child parser for instantiation at a given _offset_ in given 
    # _dialect_ (same dialect than self if dialect is nil) and with an output 
    # _buffer_.
    #
    def parse(offset, dialect=nil, buffer=nil)
      dialect = ensure_dialect(dialect.nil? ? self.dialect : dialect)
      buffer  = dialect.factor_buffer if buffer.nil?
      branch(:offset => offset, :dialect => dialect, :buffer => buffer) do
        instantiate
      end
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
  
    # Yields the block in a new scope branch, pushing pairing values on it.
    # Original scope is restored after that. Returns what the yielded block
    # returned.
    def branch_scope(pairing = {}, which = :all)
      raise ArgumentError, "Parser.branch_scope expects a block" unless block_given?
      branch(:scope => pairing, :shared => which) { yield }
    end
    
    # Adds a key/value pair on the current scope.
    def scope_define(key, value)
      state.scope[key] = value
    end

    ###################################################################### Facade on the hosted language
  
    #
    # Evaluates a ruby expression on the current context. 
    # See WLang::Parser::Context#evaluate.
    #
    def evaluate(expression)
      hosted.evaluate(expression, state)
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
    
    # Protected methods are...
    protected :hosted, :offset, :source_text, :buffer, :dialect
    
  end # class Parser
end # module WLang
