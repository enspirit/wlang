module WLang
  class Compiler
    class Filter < Temple::Filter

      module ClassMethods

        def recurse_on(*kinds)
          kinds.each do |kind|
            define_method(:"on_#{kind}") do |*args|
              recurse(kind, *args)
            end
          end
        end

      end
      extend ClassMethods

      module InstanceMethods

        def recurse(kind, *args)
          args.inject [kind] do |rw,arg|
            rw << (arg.is_a?(Array) ? call(arg) : arg)
          end
        end

      end
      include InstanceMethods

      recurse_on :template, :fn, :wlang, :strconcat, :modulo, :static
    end # class Filter
  end # class Compiler
end # module WLang