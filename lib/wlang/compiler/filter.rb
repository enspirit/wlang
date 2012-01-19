module WLang
  class Compiler
    class Filter < Temple::Filter

      def self.recurse_on(*kinds)
        kinds.each do |kind|
          define_method(:"on_#{kind}") do |*args|
            args.inject [kind] do |rw,arg|
              rw << (arg.is_a?(Array) ? call(arg) : arg)
            end
          end
        end
      end

    end # class Filter
  end # class Compiler
end # module WLang