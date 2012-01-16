module WLang
  class Dialect
    
    def dispatch(symbols, *args)
      self.class.dispatch(self, symbols, args)
    end
    
  end # class Dialect
end # module WLang
require 'wlang/dialect/class_methods'