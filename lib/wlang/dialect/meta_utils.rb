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
      
      def normalize_fns(fns, arity)
        fns.fill(nil, fns.length, arity - fns.length)
        [fns[0...arity], fns[arity..-1]]
      end
      
      def dispatch_name(symbols, prefix = "_drule")
        chars = if RUBY_VERSION >= "1.9"
          symbols.chars.map{|s| s.ord}.join("_")
        else
          symbols.chars.map{|s| s[0]}.join("_")
        end
        "#{prefix}_#{chars}".to_sym
      end
      
      def define_rule_method(symbols, code)
        case code
        when Symbol
          define_rule_method(symbols, instance_method(code))
        when Proc
          rulename = dispatch_name(symbols, "_rule")
          define_method(rulename, code)
          define_rule_method(symbols, rulename)
        when UnboundMethod
          methname = dispatch_name(symbols)
          arity    = fn_arity(code)
          define_method(methname) do |*fns|
            args, rest = self.class.normalize_fns(fns, arity)
            instantiated = code.bind(self).call(*args)
            flush_trailing_fns(instantiated, nil, rest)
          end
        else
          raise "Unable to use #{code} for a rule"
        end
      end
      
    end
    extend MetaUtils
  end # class Daialect
end # module WLang
