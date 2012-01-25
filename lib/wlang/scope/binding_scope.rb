module WLang
  class Scope
    class BindingScope < Scope

      def fetch(k, &blk)
        subject.eval(k.to_s)
      rescue NameError
        parent.fetch(k, &blk)
      end

    end # class ProxyScope
  end # class Scope
end # module WLang
