module WLang
  class Scope
    class ProxyScope < Scope

      def fetch(key, &blk)
        subject.fetch(key) do
          safe_parent.fetch(key, &blk)
        end
      end

      def inspect
        subject.inspect
      end
      alias :to_s :inspect

    end # class ProxyScope
  end # class Scope
end # module WLang
