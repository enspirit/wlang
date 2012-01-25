module WLang
  class Scope
    class ProxyScope < Scope

      def each_frame(&blk)
        subject.each_frame(&blk)
        parent.each_frame(&blk)
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
