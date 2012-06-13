module WLang
  class Scope
    class BindingScope < Scope

      def fetch(key, dialect = nil, unfound = nil)
        subject.eval(key.to_s)
      rescue NameError
        safe_parent.fetch(key, dialect, unfound)
      end

      def inspect
        "BindingScope(#{subject.inspect})"
      end
      alias :to_s :inspect

    end # class ProxyScope
  end # class Scope
end # module WLang
