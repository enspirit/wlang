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
  
  #
  # Creates a template instance.
  #
  def initialize(source, dialect, context=nil, block_symbols=:braces)
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
  def instantiate(buffer="", context=nil)
    unless context.nil? 
      @context.push(context)
    end
    parser = WLang::Parser.instantiator(self, buffer)
    instantiated = parser.instantiate
    unless context.nil?
      @context.pop
    end
    instantiated[0]
  end
  
end # class Template
  
end # module WLang