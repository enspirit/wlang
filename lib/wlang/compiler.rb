module WLang
  class Compiler < Temple::Filter

    def on_template(fn)
      call(fn)
    end
    
    def on_strconcat(*cases)
      [:multi] + cases.map{|c| call(c)}
    end
    
    def on_wlang(symbols, *functions)
      [:wlang, symbols] + functions.map{|f| call(f)}
    end
    
    def on_fn(code)
      [:proc, call(code)]
    end
    
  end # class Compiler
end # module WLang