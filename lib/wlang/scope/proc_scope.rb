module WLang
  class Scope
    class ProcScope < Scope

      def fetch(key, &blk)
        Scope.coerce(subject.call).fetch(key) do
          safe_parent.fetch(key, &blk)
        end
      end

      def inspect
        subject.inspect
      end
      alias :to_s :inspect

    end # class ProcScope
  end # class Scope
end # module WLang
