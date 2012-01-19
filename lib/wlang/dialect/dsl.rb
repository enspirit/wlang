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

        def render(fn, scope = nil, buffer = "")
          case fn
          when Template
            fn.call(scope || @scope, buffer)
          when Proc
            if scope.nil?
              fn.call(self, buffer)
            else
              with_scope(scope){ fn.call(self, buffer) }
            end
          when String
            buffer << fn
          else
            raise ArgumentError, "Unable to render #{fn}"
          end
        end

      end

      def self.included(mod)
        mod.instance_eval{ include(InstanceMethods) }
        mod.extend(ClassMethods)
      end

    end # module DSL
  end # class Dialect
end # module WLang