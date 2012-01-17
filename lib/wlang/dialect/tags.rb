module WLang
  class Dialect
    module Tags
      
      module ClassMethods
        
        def tag(symbols, method = nil, &block)
          define_tag_method(symbols, method || block)
        end
        
        def tag_dispatching_name(symbols, prefix = "_dtag")
          chars = if RUBY_VERSION >= "1.9"
            symbols.chars.map{|s| s.ord}.join("_")
          else
            symbols.chars.map{|s| s[0]}.join("_")
          end
          "#{prefix}_#{chars}".to_sym
        end
        
        private
        
        def define_tag_method(symbols, code)
          case code
          when Symbol
            define_tag_method(symbols, instance_method(code))
          when Proc
            rulename = tag_dispatching_name(symbols, "_tag")
            define_method(rulename, code)
            define_tag_method(symbols, rulename)
          when UnboundMethod
            methname = tag_dispatching_name(symbols)
            arity    = code.arity
            define_method(methname) do |*fns|
              args, rest = normalize_tag_fns(fns, arity)
              instantiated = code.bind(self).call(*args)
              flush_trailing_fns(instantiated, nil, rest)
            end
          else
            raise "Unable to use #{code} for a tag"
          end
        end
        
      end # module ClassMethods
      
      module InstanceMethods
        
        def dispatch(symbols, *fns)
          if respond_to?(meth = self.class.tag_dispatching_name(symbols))
            send meth, *fns
          else
            flush_trailing_fns("", symbols, fns)
          end
        end

        private
        
        def normalize_tag_fns(fns, arity)
          fns.fill(nil, fns.length, arity - fns.length)
          [fns[0...arity], fns[arity..-1]]
        end
        
      end # module InstanceMethods
      
      def self.included(mod)
        mod.instance_eval{ include(Tags::InstanceMethods) }
        mod.extend(ClassMethods)
      end
      
    end # module Tags
  end # class Dialect
end # module WLang