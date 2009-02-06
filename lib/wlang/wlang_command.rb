require 'wlang'
require 'wlang/wlang_command_options'
require 'wlang/standard_dialects'
module WLang
  
#
# Provides the _wlang_ commandline tool.
#
class WLangCommand
  
  # Creates a commandline instance.
  def initialize()
  end

  # Run _wlang_ commandline on specific arguments 
  def run(args)
    # parse the options
    options = Options.new.parse(args)
    
    # get output buffer
    buffer = STDOUT
    if options.output_file
      buffer = File.new(options.output_file, "w")
    end
    
    source = File.readlines(options.template_file).join
    dialect = options.source_dialect
    braces = options.template_brace
    template = WLang::Template.new(source, dialect, nil, braces)
    
    if options.verbosity>1
      puts "Instantiating #{options.template_file}"
      puts "Using dialect #{dialect} : #{dialect.class}"
      puts "Block delimiters are " << Template::BLOCK_SYMBOLS[braces].inspect
    end
    
    template.instantiate(buffer)
    
    # Flush and close if needed
    if File===buffer
      buffer.flush
      buffer.close
    end
  end
    
end # class WLang
  
end # module WLang