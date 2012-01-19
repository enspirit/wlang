module WLang
  class ToRubyAbstraction < Compiler::Filter

    recurse_on :template, :dispatch

    def on_strconcat(*cases)
      [:multi] + cases.map{|c| call(c)}
    end

    def on_fn(code)
      [:proc, call(code)]
    end

  end # class ToRubyAbstraction
end # module WLang
