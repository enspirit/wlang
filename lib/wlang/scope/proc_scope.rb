module WLang
  class Scope
    class ProcScope < Scope

      def fetch(key, dialect = nil, unfound = nil)
        scoped = Scope.coerce(subject.call)
        fallbk = lambda{ safe_parent.fetch(key, dialect, unfound) }
        scoped.fetch(key, dialect, fallbk)
      end

      def inspect
        subject.inspect
      end
      alias :to_s :inspect

    end # class ProcScope
  end # class Scope
end # module WLang
