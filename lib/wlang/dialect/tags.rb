module WLang
  class Dialect
    module Tags

      module ClassMethods

        protected

        def tag(symbols, dialects = nil, method = nil, &block)
          if block
            tag(symbols, dialects, block)
          else
            dialects, method = nil, dialects if method.nil?
            define_tag_method(symbols, dialects, method)
          end
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

    end # module Tags
  end # class Dialect
end # module WLang