module WLang
  class Template

    attr_reader :dialect, :inner_proc

    def initialize(dialect, inner_proc)
      @dialect    = dialect
      @inner_proc = inner_proc
    end

    def call(scope = {}, buffer = '')
      d = @dialect.dup
      d.send(:render, inner_proc, scope, buffer)
    end
    alias :render :call

  end # class Template
end # module WLang
