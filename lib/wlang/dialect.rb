module WLang
  class Dialect

    def initialize(context)
      @context = context
    end

    def wlang(symbols, fns)
      if symbols == "$"
        execution(fns)
      else
        fns.inject(symbols.dup){|buf,fn|
          fn.call(self, buf)
        }
      end
    end
    
    def execution(fns)
      @context.instance_eval fns.first.call(self, "")
    end

  end # class Dialect
end # module WLang