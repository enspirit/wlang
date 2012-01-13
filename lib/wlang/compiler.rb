module WLang
  class Compiler < Temple::Filter

    def on_template(fn)
      call(fn)
    end
    
    def on_strconcat(*cases)
      [:multi] + cases.map{|c| call(c)}
    end
    
    def on_wlang(symbols, *functions)
      functions = functions.map{|fn| call(fn) }
      ids       = functions.map{|fn| fn[1]    }
      code      = [:dynamic, "wlang(#{symbols.inspect}, [#{ids.join(', ')}])"]
      ([:multi] + functions + [code])
    end
    
    def on_fn(code)
      [:proc, unique_name, call(code)]
    end
    
  end # class Compiler
end # module WLang