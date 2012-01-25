module WLang
  class Scope
    class ProxyScope < Scope

      def each_frame(&blk)
        subject.each_frame(&blk)
        super
      end

      def fetch(key)
        catch :fail do
          return subject.fetch(key)
        end
        parent.fetch(key)
      end

    end # class ProxyScope
  end # class Scope
end # module WLang
