module WLang
  class Template < Proc
  
    def initialize(dialect, &compiled)
      @dialect = dialect
      super(&compiled)
    end
  
    def call(scope = {})
      @dialect.with_scope(scope){
        super(@dialect, "")
      }
    end
  
  end # class Template
end # module WLang