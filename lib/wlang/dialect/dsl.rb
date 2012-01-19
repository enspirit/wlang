module WLang
  class Dialect
    module DSL
      
      module ClassMethods
        
        protected
        
        def tag(symbols, method = nil, &block)
          define_tag_method(symbols, method || block)
        end
        
      end
      
      module InstanceMethods
        
        protected
        
        attr_reader :scope
        
        def instantiate(fn, scope = @scope, buffer = "")
          case fn
          when Template
            fn.call(scope, buffer)
          when Proc
            with_scope(scope){ fn.call(self, buffer) }
          when String
            self.class.instantiate(fn, scope, buffer)
          end
        end
        
        def evaluate(what)
          what = instantiate(what) unless what.is_a?(String)
          what.strip == "self" ? scope : scope.instance_eval(what)
        end
        
        def with_scope(scope)
          old, @scope = @scope, Scope.factor(scope)
          res = yield
          @scope = scope
          res
        end
        
        def known?(what)
          @scope.respond_to?(what.to_sym)
        end
        
      end
      
      def self.included(mod)
        mod.instance_eval{ include(InstanceMethods) }
        mod.extend(ClassMethods)
      end
      
    end # module DSL
  end # class Dialect
end # module WLang