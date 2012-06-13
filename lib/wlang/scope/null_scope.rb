module WLang
  class Scope
    class NullScope < Scope

      def initialize
        super(nil,nil)
      end

      def push(x)
        Scope.coerce(x)
      end

      def pop
        nil
      end

      def fetch(key)
        block_given? ? yield : throw(:fail)
      end

      def inspect
        "NullScope"
      end
      alias :to_s :inspect

    end # class NullScope
  end # class Scope
end # module WLang
