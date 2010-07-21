module WLang
  # 
  # Template in a given wlang dialect and expecting :braces, :brackets or 
  # :parentheses as block delimiters. A template is an abstraction over a 
  # wlang source text. It also provides utilities to create friendly location
  # messages for offsets in the source text.
  #
  class Template
  
    # Recognized symbols for blocks
    BLOCK_SYMBOLS = {:braces   => ['{', '}'],
                     :brackets => ['[', ']'],
                     :parentheses => ['(', ')']}
  
    # Template wlang dialect (wlang/...)
    attr_reader :dialect

    # Block symbols
    attr_reader :block_symbols
  
    # Attached file source
    attr_accessor :source_file
  
    # Creates a template instance.
    def initialize(source, dialect, block_symbols = :braces)
      dialect = WLang::dialect(dialect)
      raise(ArgumentError, "Source is mandatory") if source.nil?
      raise(ArgumentError, "Dialect instance expected for dialect, #{dialect} received") unless Dialect===dialect
      @source = source
      @dialect = dialect
      @block_symbols = block_symbols
    end
  
    # Resolved a relative uri
    def file_resolve(uri, exists=false)
      require 'uri'
      real_uri = URI::parse(uri)
      if real_uri.absolute?
        raise WLang::Error, "Unable to resolve #{uri}, absolute uri are not supported"
      elsif real_uri.path[0, 1] == '/'
        real_uri.path
      else
        raise WLang::Error, "Unable to resolve #{uri}, this template is not attached to a file" unless @source_file
        target = File.join(File.dirname(@source_file), uri)
        if exists and not(File.exists?(target))
          raise WLang::Error, "File '#{uri}' does not exists"
        end
        target
      end
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
  
    # Instantiates the template, with optinal context and hosted language.
    def instantiate(context = {}, hosted = ::WLang::HostedLanguage.new)
      p = ::WLang::Parser.new(hosted, self, context)
      p.instantiate[0]
    end
    
    # Returns a friendly position of an offset in the source text
    def where(offset)
      src = source_text
      source_file = self.source_file ? File.expand_path(self.source_file) : "no source file"
      "#{source_file || 'inline template'}:#{src.__wlang_line_of(offset)}:#{src.__wlang_column_of(offset)-1}"
    end
    
    # Raises a WLang::Error for the given offset
    def error(offset, msg = "")
      raise WLang::Error, "#{where(offset)} #{msg}"
    end
    
    # Raises a friendly ParseError, with positions and so on
    def parse_error(offset, msg = "")
      src = source_text
      ex = ParseError.new("#{where(offset)} #{msg}")
      ex.line, ex.column = src.__wlang_line_of(offset), src.__wlang_column_of(offset)-1
      raise ex
    end
  
  end # class Template
  
end # module WLang