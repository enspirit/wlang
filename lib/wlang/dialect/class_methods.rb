module WLang
  class Dialect
    module ClassMethods
      
      def mapping
        @mapping ||= {}
      end
      
      def rule(symbols, method = nil, &block)
        method ||= block
        if method.is_a?(Proc)
          methodname = symbols2method(symbols)
          define_method(methodname, &method)
          method = methodname
        end
        mapping[symbols] = method
      end
      
      private
      
      def method_for(symbols)
        mapping[symbols]
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