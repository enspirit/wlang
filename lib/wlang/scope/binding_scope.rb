module WLang
  class Scope
    class BindingScope < Scope

      def fetch(k, &blk)
        subject.eval(k.to_s)
      rescue NameError
        safe_parent.fetch(k, &blk)
      end

      def inspect
        "BindingScope(#{subject.inspect})"
      end
      alias :to_s :inspect

    end # class ProxyScope
  end # class Scope
end # module WLang
