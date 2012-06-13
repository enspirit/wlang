module WLang
  class Template

    # Compilation options for the template, as initially passed to `new`
    attr_reader :options

    # The dialect class to use
    attr_reader :dialect

    # The underlying template compiler
    attr_reader :compiler

    # Creates a template instance
    def initialize(source, options = {})
      @options          = options
      @dialect          = @options.delete(:dialect) || WLang::Html
      @dialect_instance = @dialect.new(options, self)
      @compiler         = Compiler.new(dialect_instance)
      @source           = Source.new(source, self).with_front_matter(yaml_front_matter?)
      @compiled         = to_ruby_proc
    end

    def path
      @options[:path] || @source.path
    end

    def locals
      @source.locals
    end

    def template_content
      @source.template_content
    end

    def to_ruby_proc
      compiler.to_ruby_proc(template_content)
    end

    def to_ruby_code
      compiler.to_ruby_code(template_content)
    end

    def to_ast
      compiler.to_ast(template_content)
    end

    def call(*args)
      scope, buffer = call_args_conventions(args)
      dialect_instance.dup.render compiled, scope, buffer
    end
    alias :render :call

    private

      attr_reader :source, :compiled, :dialect_instance

      def yaml_front_matter?
        opt = options[:yaml_front_matter]
        opt.nil? or opt
      end

      def call_args_conventions(args)
        args << '' unless args.last.respond_to?(:<<)
        buffer = args.pop
        args << self.locals unless self.locals.empty?
        scope  = WLang::Scope.chain(args)
        [scope, buffer]
      end

  end # class Template
end # module WLang
