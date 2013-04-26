module WLang
  class Scope
    class ObjectScope < Scope

      def fetch(key, dialect = nil, unfound = nil)
        s = subject

        # self special case
        if key == :self
          return s
        end

        # hash indirect access
        if s.respond_to?(:has_key?)
          return s[key]      if s.has_key?(key)
          return s[key.to_s] if s.has_key?(key.to_s)
        end

        # getter
        if s.respond_to?(key)
          return s.send(key)
        end

        safe_parent.fetch(key, dialect, unfound)
      rescue NameError
        safe_parent.fetch(key, dialect, unfound)
      end

      def to_s
        subj = subject.is_a?(Scope) ? subject.to_s : subject.class
        "ObjectScope(#{subj})"
      end

      def inspect
        "ObjectScope(#{subject.inspect})"
      end

    end # class ProxyScope
  end # class Scope
end # module WLang
