module WLang
  class FrontMatter

    attr_reader :locals
    attr_reader :source_text

    def initialize(text, compiler)
      @locals      = {}
      @source_text = text
      compile(compiler)
    end

    private

      def compile(compiler)
        return unless source_text =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

        require 'yaml'
        yaml, @source_text = YAML::load($1), $'
        
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

  end # class FrontMatter
end # module WLang