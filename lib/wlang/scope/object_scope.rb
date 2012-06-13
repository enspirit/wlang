module WLang
  class Scope
    class ObjectScope < Scope

      def fetch(k, &blk)
        s = subject

        # self special case
        if k == :self
          return s
        end

        # hash indirect access
        if s.respond_to?(:has_key?)
          return s[k]      if s.has_key?(k)
          return s[k.to_s] if s.has_key?(k.to_s)
        end

        # getter
        if s.respond_to?(k)
          return s.send(k)
        end

        safe_parent.fetch(k, &blk)
      rescue NameError
        safe_parent.fetch(k, &blk)
      end

      def inspect
        "ObjectScope(#{subject.inspect})"
      end
      alias :to_s :inspect

    end # class ProxyScope
  end # class Scope
end # module WLang
