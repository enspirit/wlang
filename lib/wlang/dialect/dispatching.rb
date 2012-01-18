module WLang
  class Dialect
    module Dispatching
      
      module ClassMethods
        
        def tag_dispatching_name(symbols, prefix = "_dtag")
          symbols = symbols.chars unless symbols.is_a?(Array)
          chars = if RUBY_VERSION >= "1.9"
            symbols.map{|s| s.ord}.join("_")
          else
            symbols.map{|s| s[0]}.join("_")
          end
          "#{prefix}_#{chars}".to_sym
        end
        
        def find_dispatching_method(symbols, subject)
          extra, symbols, found = [], symbols.chars.to_a, nil
          begin
            meth = tag_dispatching_name(symbols)
            if subject.respond_to?(meth)
              found = meth
              break
            else
              extra << symbols.shift
            end
          end until symbols.empty?
          [extra.join, found]
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
            methname = tag_dispatching_name(symbols, "_dtag")
            arity    = code.arity
            define_method(methname) do |buf, fns|
              args, rest = normalize_tag_fns(fns, arity)
              buf << code.bind(self).call(*args)
              flush_trailing_fns(buf, rest)
            end
          else
            raise "Unable to use #{code} for a tag"
          end
        end
        
      end # module ClassMethods
      
      module InstanceMethods
        
        def dispatch(symbols, buf, *fns)
          extra, meth = find_dispatching_method(symbols)
          buf << extra unless extra.empty?
          if meth
            send(meth, buf, fns)
          else
            flush_trailing_fns(buf, fns)
          end
        end
        
        private
        
        def tag_dispatching_name(symbols)
          self.class.tag_dispatching_name(symbols)
        end
        
        def find_dispatching_method(symbols, subject = self)
          self.class.find_dispatching_method(symbols, subject)
        end
        
        def normalize_tag_fns(fns, arity)
          fns.fill(nil, fns.length, arity - fns.length)
          [fns[0...arity], fns[arity..-1]]
        end
        
        def flush_trailing_fns(buf, fns)
          start, stop = braces
          fns.each do |fn|
            buf << start
            fn.call(self, buf)
            buf << stop
          end
          buf
        end
        
      end # module InstanceMethods
      
      def self.included(mod)
        mod.instance_eval{ include(Dispatching::InstanceMethods) }
        mod.extend(ClassMethods)
      end
      
    end # module Dispatching
  end # class Dialect
end # module WLang