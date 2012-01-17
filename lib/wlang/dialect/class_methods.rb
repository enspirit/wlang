module WLang
  class Dialect
    module ClassMethods
      
      def compile(template, braces = WLang::BRACES)
        new(braces).send(:compile, template)
      end
      
      def rule(symbols, method = nil, &block)
        define_rule_method(symbols, method_code(method || block))
      end
      
    end
    extend ClassMethods
  end # class Daialect
end # module WLang
