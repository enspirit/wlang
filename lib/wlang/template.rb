module WLang
  class Template < Proc
  
    def initialize(dialect, &compiled)
      @dialect = dialect
      super(&compiled)
    end
  
    def call(scope = {})
      d = @dialect.dup
      d.send(:with_scope, scope) do
        super(d, "")
      end
    end
  
  end # class Template
end # module WLang
