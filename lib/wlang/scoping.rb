module WLang
  module Scoping

    module Strict

      attr_reader :scope

      def with_scope(x)
        old, @scope = scope, x
        yield
      ensure
        @scope = old
      end

      def each_scope
        block_given? ? yield(scope) : [scope].compact.each
      end

    end # module Strict

    module Stack

      def scope
        @scope ||= []
      end

      def with_scope(x)
        scope.push x
        yield
      ensure
        scope.pop
      end

      def each_scope
        scope.each
      end

    end # module Stack

  end # module Scoping
end # module WLang