module WLang
  class Template < Proc
  
    attr_reader :dialect, :inner_proc
  
    def initialize(dialect, &inner_proc)
      @dialect    = dialect
      @inner_proc = inner_proc
      super(&inner_proc)
    end
  
    def call(scope = {}, buffer = '')
      d = @dialect.dup
      d.send(:with_scope, scope) do
        super(d, buffer)
      end
    end
  
  end # class Template
end # module WLang
