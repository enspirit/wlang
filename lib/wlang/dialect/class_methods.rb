module WLang
  class Dialect
    module ClassMethods
      
      def mapping
        @mapping ||= {}
      end
      
      def rule(symbols, method = nil, &block)
        method ||= block
        method = install_rule_method(symbols, method) if method.is_a?(Proc)
        mapping[symbols] = method
      end
      
      private
      
      def method_for(symbols)
        mapping[symbols]
      end
      
      def install_rule_method(symbols, block)
        methodname = symbols2method(symbols)
        define_method(methodname, &block)
        method = methodname
      end
      
      def symbols2method(symbols)
        chars = if RUBY_VERSION >= "1.9"
          symbols.chars.map{|s| s.ord}.join("_")
        else
          symbols.chars.map{|s| s[0]}.join("_")
        end
        "_dynamic_#{chars}".to_sym
      end
      
    end
    extend ClassMethods
  end # class Daialect
end # module WLang