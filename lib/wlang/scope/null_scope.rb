module WLang
  class Scope
    class NullScope < Scope

      def initialize
        super(nil)
      end

      def fetch(key)
        block_given? ? yield : throw(:fail)
      end

      def subjects
        []
      end

      def inspect
        "NullScope"
      end
      alias :to_s :inspect

    protected

      def append(x)
        x
      end

      def prepend(x)
        x
      end

    end # class NullScope
  end # class Scope
end # module WLang
