module WLang
  class Dialect
    class Scope
      
      def initialize(subject, parent = nil)
        @subject, @parent = subject, parent
      end
      
      def push(x)
        Scope.new(x, self)
      end
      
      def pop
        @parent
      end
      
      def each_frame(&blk)
        blk.call(@subject)
        @parent.each_frame(&blk) if @parent
      end
      
      def to_a
        seen = []
        each_frame{|f| seen << f}
        seen
      end
      
    end # class Scope
  end # class Dialect
end # module WLang