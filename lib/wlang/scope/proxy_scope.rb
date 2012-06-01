module WLang
  class Scope
    class ProxyScope < Scope

      def fetch(key, &blk)
        subject.fetch(key) do
          parent.fetch(key, &blk)
        end
      end

    end # class ProxyScope
  end # class Scope
end # module WLang
