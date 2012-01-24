module WLang
  class Dialect
    module Evaluation

      def evaluate_through_hash(scope, expr)
        throw :fail unless scope.respond_to?(:has_key?)
        if scope.has_key?(expr)
          scope[expr]
        elsif scope.has_key?(sym = expr.to_sym)
          scope[sym]
        else
          throw :fail
        end
      end

      def evaluate_through_send(scope, expr)
        if scope.respond_to?(sym = expr.to_sym)
          scope.send(sym)
        else
          throw :fail
        end
      end

      def evaluate_through_eval(scope, expr)
        if scope.is_a?(Binding)
          eval(expr.to_s, scope)
        else              
          scope.instance_eval(expr.to_s)
        end
      rescue NameError, NoMethodError
        throw :fail
      end

      def evaluate(expr)
        expr = render(expr) unless expr.is_a?(String) or expr.is_a?(Symbol)
        each_scope_frame do |s|
          catch(:fail){ return evaluate_through_hash(s,expr) }
          catch(:fail){ return evaluate_through_send(s,expr) }
          catch(:fail){ return evaluate_through_eval(s,expr) }
        end
        raise NameError, "Unable to evaluate expression '#{expr}' on #{scope.inspect}"
      end

    end # module Evaluation
  end # class Dialect
end # module WLang