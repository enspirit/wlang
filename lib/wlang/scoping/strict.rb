module WLang
  module Scoping
    module Strict

      attr_reader :scope

      def with_scope(x)
        old, @scope = @scope, x
        yield
      ensure
        @scope = old
      end

      def each_scope
        block_given? ? yield(scope) : [scope].compact.each
      end

    end # module Strict
  end # module Scoping
end # module WLang