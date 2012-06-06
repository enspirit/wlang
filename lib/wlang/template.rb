module WLang
  class Template

    attr_reader :dialect, :compiled_proc

    def initialize(dialect, compiled_proc)
      @dialect       = dialect
      @compiled_proc = compiled_proc
    end

    # def self.new(source, options)
    #   dialect   = (options[:dialect] || WLang::Html).factor(options)
    #   compiler  = Compiler.new(dialect)
    #   ruby_proc = compiler.to_ruby_proc(source)
    #   super(dialect, ruby_proc)
    # end

    def call(scope = {}, buffer = '')
      @dialect.dup.render compiled_proc, scope, buffer
    end
    alias :render :call

  end # class Template
end # module WLang
