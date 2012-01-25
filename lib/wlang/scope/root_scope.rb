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
        block_given? ? yield(key) : throw(:fail)
      end

    end # class RootScope
  end # class Scope
end # module WLang
