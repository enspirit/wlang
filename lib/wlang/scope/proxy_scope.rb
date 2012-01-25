module WLang
  class Scope
    class ProxyScope < Scope

      def fetch(key)
        catch :fail do
          return subject.fetch(key)
        end
        parent.fetch(key)
      end

    end # class ProxyScope
  end # class Scope
end # module WLang
