module WLang
  class Compiler < Temple::Filter
    
    def dialect
      options[:dialect]
    end
    
    def braces
      (dialect && dialect.braces) || options[:braces]
    end
    
    def on_template(fn)
      call(fn)
    end
    
    def on_strconcat(*cases)
      [:multi] + cases.map{|c| call(c)}
    end
    
    def on_wlang(symbols, *functions)
      # Compile functions with a fresh new compiler
      # (they might be defined in another dialect)
      c    = Compiler.new(:braces => braces)
      args = functions.map{|f| c.call(f)}
      
      # Apply dispatching rules on this dialect now
      if dialect
        meth = dialect.dispatch_name(symbols)
        if dialect.respond_to?(meth)
          [ :dispatch, :static, meth ] + args
        else
          multi = [ :strconcat ]
          multi << [:static, symbols ]
          args.each{|blk| 
            multi << [:static, braces.first]
            multi << blk.last
            multi << [:static, braces.last]
          }
          call(multi)
        end
      else
        [ :dispatch, :dynamic, symbols ] + args
      end
    end
    
    def on_fn(code)
      [:proc, call(code)]
    end
    
  end # class Compiler
end # module WLang
