module WLang
  class Dialect
    module ClassMethods
      
      def rule(symbols, method = nil, &block)
        define_rule_method(symbols, method_code(method || block))
      end
      
    end
    extend ClassMethods
  end # class Daialect
end # module WLang