module WLang
  class Scope
    class RootScope < Scope

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
        "RootScope"
      end
      alias :to_s :inspect

    end # class RootScope
  end # class Scope
end # module WLang
