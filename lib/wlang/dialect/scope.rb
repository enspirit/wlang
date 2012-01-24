module WLang
  class Dialect
    class Scope
      
      def initialize
        @stack = []
      end
      
      def self.coerce(x)
        if x.is_a?(Scope)
          x
        else
          Scope.new.push(x)
        end
      end
      
      def push(x)
        @stack.push(x)
        self
      end
      
      def pop
        @stack.pop
        self
      end
      
      def each_frame(&blk)
        @stack.reverse_each(&blk)
      end
      
      def to_a
        @stack.dup
      end
      
    end # class Scope
  end # class Dialect
end # module WLang