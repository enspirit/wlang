module WLang
  class Scope
    class NullScope < Scope

      def initialize
        super(nil,nil)
      end

      def pop
        raise "Unable to pop from root scope"
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
