module WLang
  class Dialect
    
    def braces
      [ "{", "}" ]
    end
    
    def dispatch(symbols, *fns)
      meth = self.class.dispatch_name(symbols)
      if respond_to?(meth)
        send meth, *fns
      else
        start, stop = braces
        fns.inject("#{symbols}"){|buf,fn| buf << start; fn.call(buf, self); buf << stop}
      end
    end
    
  end # class Dialect
end # module WLang
require 'wlang/dialect/class_methods'