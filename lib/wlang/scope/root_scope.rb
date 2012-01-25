module WLang
  class Scope
    class RootScope < Scope

      def initialize
        super(nil,nil)
      end

      def pop
        raise "Unable to pop from root scope"
      end

      def each_frame(&blk)
      end

      def fetch(expr)
        throw :fail
      end

    end # class RootScope
  end # class Scope
end # module WLang
