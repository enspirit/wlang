module WLang
  class Dialect
    module Dispatching

      module ClassMethods

        def tag_dispatching_name(symbols, prefix = "_tag")
          symbols = symbols.chars unless symbols.is_a?(Array)
          chars   = symbols.map{|s| s.ord}.join("_")
          "#{prefix}_#{chars}".to_sym
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

        private

        def tag_dispatching_name(symbols)
          self.class.tag_dispatching_name(symbols)
        end

      end # module InstanceMethods

      def self.included(mod)
        mod.instance_eval{ include(Dispatching::InstanceMethods) }
        mod.extend(ClassMethods)
      end

    end # module Dispatching
  end # class Dialect
end # module WLang
