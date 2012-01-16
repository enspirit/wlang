module WLang
  class Dialect
    
    attr_reader :braces
    
    def initialize(braces = [ "{", "}" ])
      @braces = braces
    end
    
    def dispatch_name(symbols)
      self.class.dispatch_name(symbols)
    end
    
    def dispatch(symbols, *fns)
      if respond_to?(meth = dispatch_name(symbols))
        send meth, *fns
      else
        start, stop = braces
        fns.inject("#{symbols}"){|buf,fn| buf << start; fn.call(buf, self); buf << stop}
      end
    end
    
    def instantiate(tpl, context = {})
      code = engine.call(tpl)
      proc = eval(code)
      proc.call(self, "")
    end
    
    private
    
    def engine
      engine = Class.new(Temple::Engine)
      engine.use WLang::Parser
      engine.use WLang::Compiler, :dialect => self
      engine.use WLang::Generator
      engine.new
    end
    
  end # class Dialect
end # module WLang
require 'wlang/dialect/meta_utils'
require 'wlang/dialect/class_methods'