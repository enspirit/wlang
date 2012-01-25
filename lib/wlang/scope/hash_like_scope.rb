module WLang
  class Scope
    class HashLikeScope < Scope

      def fetch(k, &blk)
        return subject if k == :self
        subject.tap do |s|
          return s[k] if s.has_key?(k)
          return s[k.to_s] if s.has_key?(k.to_s)
        end
        parent.fetch(k, &blk)
      end

    end # class ProxyScope
  end # class Scope
end # module WLang
