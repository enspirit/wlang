module WLang
  class Template

    # Source of this template, as initially passed to `new`
    attr_reader :source

    # Compilation options for the template, as initially passed to `new`
    attr_reader :options

    # Main dialect of the template
    attr_reader :dialect

    # Creates a template instance
    def initialize(source, options = {})
      @source   = source
      @options  = options
      @dialect  = (options[:dialect] || WLang::Html)
      @compiled = compiler.to_ruby_proc(@source)
    end

    def to_ruby_proc
      compiler.to_ruby_proc(source)
    end

    def to_ruby_code
      compiler.to_ruby_code(source)
    end

    def to_ast
      compiler.to_ast(source)
    end

    def call(scope = {}, buffer = '')
      dialect_instance.render @compiled, scope, buffer
    end
    alias :render :call

    private

      def dialect_instance
        dialect.factor(options)
      end

      def compiler
        Compiler.new(dialect_instance)
      end

  end # class Template
end # module WLang
