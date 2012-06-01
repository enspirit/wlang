module WLang
  class Dialect
    module Evaluation

      def scope
        @scope ||= Scope.root
      end

      def with_scope(x)
        @scope = scope.push(x)
        res    = yield
        @scope = scope.pop
        res
      end

      def evaluate(expr, *default)
        case expr
        when Symbol, String
          catch(:fail) do
            return scope.evaluate(expr, *default)
          end
          raise NameError, "Unable to find #{expr} on #{scope}"
        else
          evaluate(render(expr), *default)
        end
      end

    end # module Evaluation
  end # class Dialect
end # module WLang