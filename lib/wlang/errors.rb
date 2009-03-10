module WLang
  
  # Main error of all WLang errors.
  class Error < StandardError; end
  
  # Error raised by a WLang parser instanciation when an error occurs. 
  class ParseError < StandardError; 

    attr_reader :line, :column

    # Creates an error with offset information
    def initialize(message, offset=nil, template=nil)
      @offset = offset
      @line, @column = parse(template) if template
      unless template and offset
        super(message) 
      else
        super("ParseError at #{@line}:#{@column} : #{message}")
      end
      
    end
    
    # Reparses the template and finds line:column locations
    def parse(template)
      template = template[0,@offset]
      if template =~ /\n/ then
        lines = template[0,@offset].split(/\n/)
      else 
        lines = [template]
      end
      line, column = lines.length, lines.last.length
      return [line, column]
    end
    
  end # class ParseError
  
end # module WLang
