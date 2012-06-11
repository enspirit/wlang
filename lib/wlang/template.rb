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
      @locals   = {}
      compile
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
        text = source_text
        if yaml_front_matter? and text =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          compile_yaml_front_matter($1)
          text = $'
        end
        @compiled = compiler.to_ruby_proc(text)
      end

      def compile_yaml_front_matter(yaml)
        require 'yaml'
        yaml = YAML::load(yaml)

        # append explicit locals
        locals.merge!(yaml.delete("locals") || {})

        # compile and append explicit partials
        partials = yaml.delete("partials")
        partials.each_pair do |k,tpl|
          locals[k] = compiler.to_ruby_proc(tpl)
        end if partials

        # append remaining data
        locals.merge!(yaml) unless yaml.empty?
      end

      def source_text
        if to_path = [:path, :to_path].find{|m| @source.respond_to?(m)}
          File.read(@source.send(to_path))
        elsif meth = [:read, :to_str].find{|m| @source.respond_to?(m)}
          @source.send(meth)
        else
          raise ArgumentError, "Invalid template source `#{@source}`"
        end
      end

  end # class Template
end # module WLang
