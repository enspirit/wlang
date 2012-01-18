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
        
        def _(fn, dialect = self)
          dialect = dialect.new if dialect.is_a?(Class)
          fn.call(dialect, "")
        end
        alias :yield_fn :_
        
        def evaluate(what, dialect = self)
          what = what.call(dialect, "") if what.is_a?(Proc)
          what.strip == "self" ? @scope : @scope.instance_eval(what)
        end
        
        public
        
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