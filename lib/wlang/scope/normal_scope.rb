module WLang
  class Scope
    class NormalScope < Scope

      def each_frame(&blk)
        blk.call(subject)
        super
      end

      def fetch(expr)
        catch :fail do
          return _fetch(expr)
        end
        super
      end

      def _fetch(expr)
        expr.inject(subject) do |s,k|
          _fetch_one(s,k)
        end
      end

      def _fetch_one(s,k)
        to_sym, to_s = k.to_sym, k.to_s
        if s.respond_to?(:has_key?)
          return s[to_sym] if s.has_key?(to_sym)
          return s[to_s]   if s.has_key?(to_s)
        end
        if s.respond_to?(to_sym)
          return s.send(to_sym)
        end
        throw :fail
      end

    end # class NormalScope
  end # class Scope
end # module WLang
