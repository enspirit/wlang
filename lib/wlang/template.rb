module WLang
  
  # 
  # Template in a given wlang dialect, providing a default context object.
  #
  class Template
  
    # Recognized symbols for blocks
    BLOCK_SYMBOLS = {:braces   => ['{', '}'],
                     :brackets => ['[', ']'],
                     :parentheses => ['(', ')']}
  
    # Template wlang dialect (wlang/...)
    attr_reader :dialect

    # Instantiation context
    attr_reader :context
    
    # Block symbols
    attr_reader :block_symbols
  
    # Attached file source
    attr_accessor :source_file
  
    #
    # Creates a template instance.
    #
    def initialize(source, dialect, context=nil, block_symbols = :braces)
      raise(ArgumentError, "Source is mandatory") if source.nil?
      if String===dialect
        dname, dialect = dialect, WLang::dialect(dialect)
        raise(ArgumentError, "Unknown dialect #{dname}") if dialect.nil?
      end     
      raise(ArgumentError, "Dialect is mandatory") unless WLang::Dialect===dialect
      @source = source
      @dialect = dialect
      @context = WLang::Parser::Context.new(context)  
      @block_symbols = block_symbols
    end
  
    # Resolved a relative uri
    def file_resolve(uri, exists=false)
      raise("Unable to resolve #{uri}, this template is not attached to a file")\
        unless @source_file
      target = File.join(File.dirname(@source_file), uri)
      if exists and not(File.exists?(target))
        raise "File '#{uri}' does not exists"
      end
      target
    end
  
    # Returns template's source text
    def source_text
      case @source
        when String
          @source
        else
          @source.to_s
      end
    end
  
    #
    # Instantiate the template, with an additional context and an output buffer.
    #
    def instantiate(buffer=nil, context=nil)
      @context.push(context) unless context.nil? 
      parser = WLang::Parser.instantiator(self, buffer)
      instantiated = parser.instantiate
      @context.pop unless context.nil?
      instantiated[0]
    end
    
    # Returns a friendly position of an offset in the source text
    def where(offset)
      src = source_text
      "#{@source_file}:#{src.__wlang_line_of(offset)}:#{src.__wlang_column_of(offset)-1}"
    end
    
    # Raises a WLang::Error for the given offset
    def error(offset, msg = "")
      src = source_text
      line, column = src.__wlang_line_of(offset), src.__wlang_column_of(offset)-1
      raise WLang::Error, "#{@source_file}:#{line}:#{column} #{msg}"
    end
    
    # Raises a friendly ParseError, with positions and so on
    def parse_error(offset, msg = "")
      src = source_text
      line, column = src.__wlang_line_of(offset), src.__wlang_column_of(offset)-1
      ex = ParseError.new("#{@source_file}:#{line}:#{column} #{msg}")
      ex.line, ex.column = line, column
      raise ex
    end
  
  end # class Template
  
end # module WLang