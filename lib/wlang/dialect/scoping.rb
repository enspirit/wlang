module WLang
  class Dialect
    module Scoping

      def scope
        @scope ||= []
      end

      def with_scope(x)
        scope.push x
        yield
      ensure
        scope.pop
      end

      def each_scope(&blk)
        scope.reverse.each(&blk)
      end

    end # module Scoping
  end # class Dialect
end # module WLang