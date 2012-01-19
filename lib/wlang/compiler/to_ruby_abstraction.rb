module WLang
  class ToRubyAbstraction < Temple::Filter
    
    def on_template(fn)
      call(fn)
    end
    
    def on_strconcat(*cases)
      [:multi] + cases.map{|c| call(c)}
    end
    
    def on_wlang(symbols, *functions)
      args = functions.map{|f| call(f)}
      [ :dispatch, :dynamic, symbols ] + args
    end
    
    def on_fn(code)
      [:proc, call(code)]
    end
    
  end # class ToRubyAbstraction
end # module WLang
