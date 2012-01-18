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
        
        def _(fn)
          fn.call(self, "")
        end
        
        def evaluate(what)
          return @scope if what.strip == "self"
          @scope.instance_eval(what)
        end
        
        def with_scope(scope)
          old, @scope = @scope, Scope.factor(scope)
          yield
        ensure
          @scope = scope
        end
        
      end
      
      def self.included(mod)
        mod.instance_eval{ include(InstanceMethods) }
        mod.extend(ClassMethods)
      end
      
    end # module DSL
  end # class Dialect
end # module WLang