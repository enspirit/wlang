module WLang
  class Dialect
    module Scoping

      def scope
        @scope ||= Scope.new({})
      end

      def with_scope(x)
        @scope = scope.push(x)
        yield
        @scope = scope.pop
      end

      def each_scope_frame(&blk)
        scope.each_frame(&blk)
      end

    end # module Scoping
  end # class Dialect
end # module WLang