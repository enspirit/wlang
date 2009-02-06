require 'optparse'
module WLang
class WLangCommand
  
#
# Options of the _wlang_ commandline
#  
class Options

  # Source template file
  attr_reader :template_file
  
  # Context file
  attr_reader :context_file
  
  # Output file
  attr_reader :output_file

  # Source dialect
  attr_reader :source_dialect
      
  # Verbose mode?
  attr_reader :verbosity
  
  # Initializes the options with default values
  def initialize
    @verbosity = 0
    @brace = 'brace'
  end
  
  # Returns kind of braces
  def template_brace
    case @brace
    when "brace", "braces", "{"
      return :braces
    when "brackets", "bracket", "["
      return :brackets
    when "parentheses", "parenthesis", "("
      return :parentheses
    else
      raise "Unknown brace kind #{brace}"
    end
  end
  
  #
  # Parses commandline options provided as an array os Strings.
  #
  def parse(argv)
    opts = OptionParser.new do |opt|
      opt.program_name = File.basename $0
      opt.version = WLang::VERSION
      opt.release = nil
      opt.summary_indent = ' ' * 4
      banner = <<-EOF
        # Usage #{opt.program_name} [options] template context
        
        # Template is parsed as a wlang dialect (based on its extension by default) and 
        # instanciated through a given context file.
      EOF
      opt.banner = banner.gsub(/[ \t]+# /, "")
      
      opt.separator nil
      opt.separator "Options:"
      
      opt.on("-d", "--dialect=DIALECT", 
             "Interpret source template as a given wlang dialect") do |value|
        @source_dialect = value
      end
      
      opt.on("-o", "--output=OUTPUT",
             "Flush instantiation result in output file") do |value|
        @output_file = value         
      end
      
      opt.on("--brace=BRACE", ["brace", "parenthesis", "bracket"],
             "Block delimiters used by the template file") do |value|
        @brace = value         
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
    rest = opts.parse!(argv)
    
    unless rest.length==2
      puts opts
      exit
    end
    
    @template_file = rest[0]
    @context_file = rest[1]
    
    install
    self
  end
  
  # Installs options, raising an error if something is invalid
  def install
    raise("File '#{@template_file}' not readable")\
      unless File.file?(@template_file) and File.readable?(@template_file)
    raise("File '#{@context_file}' not readable")\
      unless File.file?(@context_file) and File.readable?(@context_file)

    unless @source_dialect
      extname = File.extname(@template_file)
      @source_dialect = WLang::FILE_EXTENSIONS[extname]
      raise("No known dialect for file extension '#{extname}'\n"\
            "Known extensions are: " << WLang::FILE_EXTENSIONS.keys.join(", "))\
        if @source_dialect.nil?
    end
  end
  
  private :install
end # class Options  

end # class WLangCommand
end # module WLang
