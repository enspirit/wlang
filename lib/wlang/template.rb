module WLang
  class Template < Proc
  
    def initialize(dialect, &compiled)
      @dialect = dialect
      super(&compiled)
    end
  
    def call(scope = {})
      @dialect.send(:with_scope, scope) do
        super(@dialect, "")
      end
    end
  
  end # class Template
end # module WLang