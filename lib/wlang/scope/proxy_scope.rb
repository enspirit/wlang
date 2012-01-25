module WLang
  class Scope
    class ProxyScope < Scope

      def each_frame(&blk)
        subject.each_frame(&blk)
        super
      end

      def fetch(expr)
        catch :fail do
          return subject.fetch(expr)
        end
        super
      end

    end # class ProxyScope
  end # class Scope
end # module WLang
