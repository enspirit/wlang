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
          return @context if what.strip == "self"
          @context.instance_eval(what)
        end
        
        def with_context(ctx)
          old, @context = @context, Scope.factor(ctx)
          yield
        ensure
          @context = ctx
        end
        
      end
      
      def self.included(mod)
        mod.instance_eval{ include(InstanceMethods) }
        mod.extend(ClassMethods)
      end
      
    end # module DSL
  end # class Dialect
end # module WLang