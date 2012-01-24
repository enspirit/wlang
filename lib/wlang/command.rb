require 'wlang'
require 'quickl'
module WLang
  #
  # wlang -- templating engine
  #
  # SYNOPSIS
  #   Usage: wlang [options] TEMPLATE
  #
  # OPTIONS:
  # #{summarized_options}
  #
  # DESCRIPTION
  #   This command invokes the wlang templating engine on TEMPLATE
  #   and flushes the rendering result on standard output.
  #
  class Command < Quickl::Command(__FILE__, __LINE__)

    options do |opt|
      @output = nil
      opt.on('--output=FILE', 'Render output in FILE') do |file|
        @output = file
      end
      @yaml_front_matter = true
      opt.on("--[no-]yaml-front-matter", 
             "Enable/disable YAML front mater (defaults to true)") do |val|
        @yaml_front_matter = val
      end
      @ast = false
      opt.on('--ast', "Debugs the AST") do
        @ast = true
      end
      @compiling_options = {}
      opt.on('--[no-]auto-spacing') do |val|
        @compiling_options[:autospacing] = val
      end
      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "#{Quickl.program_name} #{WLang::VERSION} (c) 2009-2012, Bernard Lambeau"
      end
    end

    def execute(argv)
      install(argv)

      compiler = @dialect.compiler(@compiling_options)
      if @ast
        require 'awesome_print'
        ap compiler.ast(@template)
      end

      with_output do |output|
        compiler.compile(@template).render(@context, output)
      end
    end

    private

    def install(argv)
      raise Quickl::Help unless argv.size == 1

      # template file
      unless File.file?(@tpl_file = argv.first)
        raise Quickl::Exit, "No such template #{tpl_file}"
      end

      # dialect
      require 'wlang/html'
      @dialect       = WLang::Html

      # template and context
      @template      = File.read(@tpl_file)
      @context       = {}

      if @yaml_front_matter and 
         @template =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        require 'yaml'
        @context.merge! YAML::load($1)
        @template = $'
      end
    end

    def with_output(&proc)
      if @output
        File.open(@output, 'w', &proc)
      else
        proc.call($stdout)
      end
    end

  end # class Command
end # module WLang