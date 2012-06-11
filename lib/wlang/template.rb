module WLang
  class Template

    # Source of this template, as initially passed to `new`
    attr_reader :source

    # Compilation options for the template, as initially passed to `new`
    attr_reader :options

    # Main dialect of the template
    attr_reader :dialect

    # The dialect instance used for compilation and rendering
    attr_reader :dialect_instance

    # The underlying template compiler
    attr_reader :compiler

    # The loaded locals
    attr_reader :locals

    # Creates a template instance
    def initialize(source, options = {})
      @source   = source
      @options  = options
      @dialect  = (options[:dialect] || WLang::Html)
      @dialect_instance = @dialect.new(options)
      @compiler = Compiler.new(dialect_instance)
      compile
    end

    def to_ruby_proc
      compiler.to_ruby_proc(source_text)
    end

    def to_ruby_code
      compiler.to_ruby_code(source_text)
    end

    def to_ast
      compiler.to_ast(source_text)
    end

    def call(locals = {}, buffer = '')
      scope = WLang::Scope.root
      scope = scope.push(self.locals) unless self.locals.empty?
      scope = scope.push(locals)
      dialect_instance.dup.render @compiled, scope, buffer
    end
    alias :render :call

    private

      def yaml_front_matter?
        opt = options[:yaml_front_matter]
        opt.nil? or opt
      end

      def compile
        if yaml_front_matter?
          front = FrontMatter.new(source_text, compiler)
          @locals   = front.locals
          @compiled = compiler.to_ruby_proc(front.source_text)
        else
          @locals = {}
          @compiled = compiler.to_ruby_proc(source_text)
        end
      end

      def source_text
        Source.new(source).raw_text
      end

  end # class Template
end # module WLang
