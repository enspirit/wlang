module WLang
  class Dialect
    module MetaUtils
      
      def method_code(meth, who = self)
        case meth
        when Proc, UnboundMethod
          meth
        when Symbol
          who.instance_method(meth)
        else
          raise ArgumentError, "Unexpected code #{meth}"
        end
      end
      
      def fn_arity(method, who = self)
        method_code(method, who).arity
      end
      
      def dispatch_name(symbols)
        chars = if RUBY_VERSION >= "1.9"
          symbols.chars.map{|s| s.ord}.join("_")
        else
          symbols.chars.map{|s| s[0]}.join("_")
        end
        "_dynamic_#{chars}".to_sym
      end
      
      def define_rule_method(symbols, code)
        methname, arity = dispatch_name(symbols), fn_arity(code)
        define_method(methname) do |*fns|
          callable     = code.is_a?(UnboundMethod) ? code.bind(self) : code
          args, rest   = fns[0...arity], fns[arity..-1]
          instantiated = callable.call(*args)
          flush_trailing_fns(instantiated, nil, rest)
        end
      end
      
    end
    extend MetaUtils
  end # class Daialect
end # module WLang