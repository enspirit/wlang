require 'wlang'
require 'quickl'
module WLang
  #
  # wlang -- templating engine
  #
  # SYNOPSIS
  #   Usage: wlang [options] TEMPLATE [ATTR1 VALUE1 ATTR2 VALUE2]
  #
  # OPTIONS:
  # #{summarized_options}
  #
  # DESCRIPTION
  #   This command invokes the wlang templating engine on TEMPLATE and flushes the
  #   rendering result on standard output.
  #
  #   Commandline template data can be passed through ATTR and VALUE arguments.
  #
  class Command < Quickl::Command(__FILE__, __LINE__)

    attr_reader :output
    attr_reader :yaml_front_matter
    attr_reader :ast
    attr_reader :compiling_options
    attr_reader :context
    attr_reader :dialect
    attr_reader :tpl_file
    attr_reader :template

    def initialize(*args)
      require 'wlang/html'
      super
      @output = nil
      @yaml_front_matter = true
      @ast = false
      @compiling_options = {}
      @context = {}
      @dialect = WLang::Html
    end

    options do |opt|
      opt.on('--output=FILE', 'Render output in FILE') do |file|
        @output = file
      end
      opt.on("--[no-]yaml-front-matter",
             "Enable/disable YAML front mater (defaults to true)") do |val|
        @yaml_front_matter = val
      end
      opt.on('--ast', "Debugs the AST") do
        @ast = true
      end
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

      if @ast
        begin
          require 'awesome_print'
          ap @template.to_ast
        rescue LoadError
          puts "HINT: install the 'awesome_print' gem for pretty output!"
          puts @template.to_ast.inspect
        end
      end

      with_output do |output|
        @template.render(@context, output)
      end
    end

    private

    def install(argv)
      raise Quickl::Help unless (argv.size % 2) == 1

      # template file
      unless (@tpl_file = Path(argv.shift)).exist?
        raise Quickl::Exit, "No such template #{tpl_file}"
      end

      # context
      argv.each_slice(2) do |(k,v)|
        @context[k] = v
      end

      # template and context
      @template = Template.new(@tpl_file, @compiling_options)
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