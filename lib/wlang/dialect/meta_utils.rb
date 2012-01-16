module WLang
  class Dialect
    module MetaUtils
      
      def method_code(meth, who = self)
        meth.is_a?(Proc) ? meth : who.instance_method(meth)
      end
      
      def dispatch_name(symbols)
        chars = if RUBY_VERSION >= "1.9"
          symbols.chars.map{|s| s.ord}.join("_")
        else
          symbols.chars.map{|s| s[0]}.join("_")
        end
        "_dynamic_#{chars}".to_sym
      end
      
      def fn_arity(method, who = self)
        method_code(method, who).arity
      end
      
      def define_rule_method(symbols, code)
        methname = dispatch_name(symbols)
        define_method(methname, code)
      end
      
    end
    extend MetaUtils
  end # class Daialect
end # module WLang