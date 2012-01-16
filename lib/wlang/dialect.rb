module WLang
  class Dialect
    
    def dispatch(symbols, *args, &blk)
      send self.class.dispatch_name(symbols), *args, &blk
    end
    
  end # class Dialect
end # module WLang
require 'wlang/dialect/class_methods'