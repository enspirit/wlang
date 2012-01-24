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
          if scope.nil?
            case fn
            when String
              buffer << fn
            when Proc
              fn.call(self, buffer)
            when Template
              fn.call(@scope, buffer)
            else
              raise ArgumentError, "Unable to render #{fn}"
            end
          else
            with_scope(scope){ render(fn, nil, buffer) }
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