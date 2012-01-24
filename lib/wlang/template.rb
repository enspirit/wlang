module WLang
  class Template

    attr_reader :dialect, :inner_proc

    def initialize(dialect, inner_proc)
      @dialect    = dialect
      @inner_proc = inner_proc
    end

    def call(scope = {}, buffer = '')
      case i = inner_proc
      when String
        buffer << i
      else
        @dialect.dup.tap do |d|
          d.send(:render, i, scope, buffer)
        end
        buffer
      end
    end
    alias :render :call

  end # class Template
end # module WLang
