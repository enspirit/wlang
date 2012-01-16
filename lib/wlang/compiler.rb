module WLang
  class Compiler < Temple::Filter
    
    def dialect
      options[:dialect]
    end
    
    def braces
      options[:braces] || [ "{", "}" ]
    end
    
    def on_template(fn)
      call(fn)
    end
    
    def on_strconcat(*cases)
      [:multi] + cases.map{|c| call(c)}
    end
    
    def on_wlang(symbols, *functions)
      args = functions.map{|f| call(f)}
      if dialect && (meth=dialect.dispatch_name(symbols))
        [ :dispatch, :static, meth ] + args
      elsif dialect
        multi = [ :strconcat ]
        multi << [:static, symbols ]
        args.each{|blk| 
          multi << [:static, braces.first]
          multi << blk.last
          multi << [:static, braces.last]
        }
        call(multi)
      else
        [ :dispatch, :dynamic, symbols ] + args
      end
    end
    
    def on_fn(code)
      [:proc, call(code)]
    end
    
  end # class Compiler
end # module WLang