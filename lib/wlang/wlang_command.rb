require 'wlang'
require 'wlang/wlang_command_options'
require 'wlang/dialects/standard_dialects'
module WLang
  
  #
  # Provides the _wlang_ commandline tool. See 'wlang --help' for documentation.
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
    
      source = File.read(options.template_file)
      dialect = options.template_dialect
      braces = options.template_brace
      context = options.context_object
      context = {options.context_name => context} unless options.context_name.nil?
      template = WLang::file_template(options.template_file, options.template_dialect, braces)
    
      if options.verbosity>1
        puts "Instantiating #{options.template_file}"
        puts "Using dialect #{dialect}"
        puts "Block delimiters are " << Template::BLOCK_SYMBOLS[braces].inspect
        puts "Context is " << context.inspect
      end
    
      buffer << template.instantiate(context)
    
      # Flush and close if needed
      if File===buffer
        buffer.flush
        buffer.close
      end
    end
    
  end # class WLang
  
end # module WLang