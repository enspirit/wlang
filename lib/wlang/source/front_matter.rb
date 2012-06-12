module WLang
  class Source
    class FrontMatter < Source

      def initialize(*args, &block)
        super
        @locals = {}
        @template_content = subject.to_str
        compile
      end

      def locals
        @locals
      end

      def template_content
        @template_content
      end

      private

        def compiler
          template.compiler
        end

        def compile
          return unless template_content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

          require 'yaml'
          yaml, @template_content = YAML::load($1), $'

          # append explicit locals
          @locals.merge!(yaml.delete("locals") || {})

          # compile explicit partials
          partials = yaml.delete("partials") || {}
          partials.each_pair do |k,tpl|
            @locals[k] = compiler.to_ruby_proc(tpl)
          end

          # append remaining data
          @locals.merge!(yaml) unless yaml.empty?
        end

    end
  end
end