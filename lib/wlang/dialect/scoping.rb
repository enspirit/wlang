module WLang
  class Dialect
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

        def each_scope(&blk)
          scope.reverse.each(&blk)
        end

      end # module Stack

      module ClassMethods

        def scoping(name)
          include Scoping.const_get(name.to_s.capitalize.to_sym)
        end

      end # module ClassMethods

      def self.included(mod)
        mod.extend(ClassMethods)
      end

    end # module Scoping
  end # class Dialect
end # module WLang