module WLang
  class Dialect
    module Evaluation

      module Strategies

        def hash_evaluator
          lambda{|scope,expr|
            return nil unless scope.respond_to?(:has_key?)
            if scope.has_key?(expr)
              [true, scope[expr]] 
            elsif scope.has_key?(sym = expr.to_sym)
              [true, scope[sym]]
            end
          }
        end
        module_function :hash_evaluator

        def send_evaluator
          lambda{|scope,expr|
            if scope.respond_to?(sym = expr.to_sym)
              [true, scope.send(sym)]
            end
          }
        end
        module_function :send_evaluator

        def eval_evaluator
          lambda{|scope,expr|
            begin
              val = if scope.is_a?(Binding)
                eval(expr.to_s, scope)
              else              
                scope.instance_eval(expr.to_s)
              end
              [true, val]
            rescue NameError, NoMethodError
              nil
            end
          }
        end
        module_function :eval_evaluator

        def nofail_evaluator
          lambda{|scope,expr| [true, nil]}
        end
        module_function :nofail_evaluator

      end # module Strategies

      module ClassMethods

        def evaluator(*names)
          chain = names.flatten.map{|name| Strategies.send("#{name}_evaluator")}
          define_method(:evaluation_chain) do
            chain
          end
        end

      end # module ClassMethods

      module InstanceMethods

        def evaluation_chain
          []
        end

        def each_evaluator
          evaluation_chain.each &Proc.new
        end

        def evaluate(expr)
          unless expr.is_a?(String) or expr.is_a?(Symbol)
            expr = render(expr) 
          end
          each_evaluator do |evaluator|
            each_scope do |scope|
              found, value = evaluator.call(scope,expr)
              return value if found
            end
          end
          raise NameError, "Unable to find #{expr}"
        end

      end # module InstanceMethods

      def self.included(mod)
        mod.instance_eval{ include(InstanceMethods) }
        mod.extend(ClassMethods)
      end

    end # module Evaluation
  end # class Dialect
end # module WLang