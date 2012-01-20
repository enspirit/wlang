module WLang
  class Dialect
    module Dispatching

      module ClassMethods

        def tag_dispatching_name(symbols, prefix = "_tag")
          symbols = symbols.chars unless symbols.is_a?(Array)
          chars   = symbols.map{|s| s.ord}.join("_")
          "#{prefix}_#{chars}".to_sym
        end

        def find_dispatching_method(symbols, subject = new)
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
          rulename = tag_dispatching_name(symbols, "_tag")
          case code
          when Symbol
            module_eval %Q{ alias :#{rulename} #{code} }
          when Proc
            define_method(rulename, code)
          else
            raise "Unable to use #{code} for a tag"
          end
        end

      end # module ClassMethods

      module InstanceMethods

        def find_dispatching_method(symbols, subject = self)
          self.class.find_dispatching_method(symbols, subject)
        end

        private

        def tag_dispatching_name(symbols)
          self.class.tag_dispatching_name(symbols)
        end

        def with_normalized_fns(fns, arity)
          if fns.size == arity
            yield(fns, nil) 
          elsif fns.size < arity
            yield(fns.fill(nil, fns.size, arity - fns.size), nil)
          else
            fns.fill(nil, fns.length, arity - fns.length)
            yield(fns[0...arity], fns[arity..-1])
          end
        end

        def flush_trailing_fns(buf, fns)
          start, stop = braces
          fns.each do |fn|
            buf << start
            render(fn, nil, buf)
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
