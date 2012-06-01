module WLang
  class Scope
    class ObjectScope < Scope

      def fetch(k, &blk)
        s = subject
        return s if k == :self
        if s.respond_to?(:has_key?)
          return s[k] if s.has_key?(k)
          return s[k.to_s] if s.has_key?(k.to_s)
        end
        return s.send(k) if s.respond_to?(k)
        parent.fetch(k, &blk)
      rescue NameError
        parent.fetch(k, &blk)
      end

      def inspect
        "ObjectScope(#{subject.inspect})"
      end
      alias :to_s :inspect

    end # class ProxyScope
  end # class Scope
end # module WLang
