module WLang
  class Source
    class FrontMatter < Source

      def initialize(*args, &block)
        super
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
          raw = raw_content
          if raw =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
            @locals, @template_content = {}, $'

            require 'yaml'
            yaml = YAML::load($1) || {}

            # append explicit locals
            @locals.merge!(yaml.delete("locals") || {})

            # compile explicit partials
            partials = yaml.delete("partials") || {}
            partials.each_pair do |k,tpl|
              @locals[k] = compiler.to_ruby_proc(tpl)
            end

            # append remaining data
            @locals.merge!(yaml) unless yaml.empty?
          else
            @locals = {}
            @template_content = raw
          end
        end

    end
  end
end