require 'optparse'
module WLang
class WLangCommand
  
#
# Options of the _wlang_ commandline
#  
class Options

  # Source template file
  attr_reader :template_file
  
  # Template dialect
  attr_reader :template_dialect
      
  # Which brace kind used in template (:braces, :brackes, :parentheses)
  attr_reader :template_brace
  
  # Context file
  attr_reader :context_file

  # Context object
  attr_reader :context_object
  
  # Context kind [:yaml, :ruby, :dsl]  
  attr_reader :context_kind

  # Name of the context
  attr_reader :context_name
    
  # Output file
  attr_reader :output_file

  # Verbose mode?
  attr_reader :verbosity
  
  # Initializes the options with default values
  def initialize
    @verbosity = 0
    @template_brace = :braces
  end
  
  #
  # Parses commandline options provided as an array of Strings.
  #
  def parse(argv)
    opts = OptionParser.new do |opt|
      opt.program_name = File.basename $0
      opt.version = WLang::VERSION
      opt.release = nil
      opt.summary_indent = ' ' * 4
      banner = <<-EOF
        # Usage #{opt.program_name} [options] template context-file
        
        # Template is parsed as a wlang dialect (based on its extension by default) and 
        # instanciated through a given context file.
      EOF
      opt.banner = banner.gsub(/[ \t]+# /, "")
      
      opt.separator nil
      opt.separator "Options:"
      
      opt.on("-d", "--dialect=DIALECT", 
             "Interpret source template as a given wlang dialect") do |value|
        @template_dialect = value
      end
      
      opt.on("-o", "--output=OUTPUT",
             "Flush instantiation result in output file") do |value|
        @output_file = value         
      end
      
      opt.on("--brace=BRACE", ["brace", "parenthesis", "bracket"],
             "Block delimiters used by the template file (braces, brackets, parentheses)") do |value|
         # handle template brace
         case value
           when "brace", "braces", "{"
             @template_brace = :braces
           when "brackets", "bracket", "["
             @template_brace = :brackets
           when "parentheses", "parenthesis", "("
             @template_brace = :parentheses
           else
             raise "Unknown brace kind #{brace}"
         end
      end
      
      opt.on("--context-name=NAME",
             "Name of the context object") do |value|
        @context_name = value         
      end
      
      opt.on("--context-kind=KIND", ["yaml", "ruby", "dsl"],
             "Kind of context object (yaml, ruby, dsl)") do |value|
        @context_kind = value         
      end
      
      opt.on("--verbose", "-v",
             "Display extra progress as we parse.") do |value|
        @verbosity = 2
      end

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opt.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opt.on_tail("--version", "Show version") do
        puts "wlang version " << WLang::VERSION << " (c) University of Louvain, Bernard & Louis Lambeau"
        exit
      end
      
      opt.separator nil
    end   
    
    # handle arguments    
    rest = opts.parse!(argv)
    if rest.length<1 or rest.length>2
      puts opts
      exit
    end
    
    # handle template file
    @template_file = rest[0]
    raise("File '#{@template_file}' not readable")\
      unless File.file?(@template_file) and File.readable?(@template_file)

    # handle context file
    if rest.length==2
      @context_file = rest[1]
      raise("File '#{@context_file}' not readable")\
        unless File.file?(@context_file) and File.readable?(@context_file)
    end
    
    # handle template dialect
    unless @template_dialect
      extname = File.extname(@template_file)
      @template_dialect = WLang::FILE_EXTENSIONS[extname]
      raise("No known dialect for file extension '#{extname}'\n"\
            "Known extensions are: " << WLang::FILE_EXTENSIONS.keys.join(", "))\
        if @template_dialect.nil?
    end
    
    # handle context kind
    if @context_file and not(@context_kind)
      extname = File.extname(@context_file)
      case extname
        when ".rb", ".ruby"
          @context_kind = :ruby
        when ".yaml", ".yml"
          @context_kind = :yaml
      else
        raise "Unable to infer context kind for extension #{extname}"
      end
    end

    # handle context object
    if @context_file
      case @context_kind
        when :yaml
          require "yaml"
          @context_object = YAML.load(File.open(@context_file))
        when :ruby, :dsl
          @context_object = Kernel.eval(File.read(@context_file))
        else
          raise "Unknown context kind #{@context_kind}"
      end
    end
        
    return self
  end
  
end # class Options  

end # class WLangCommand
end # module WLang
