module Tilt
  class WLangTemplate < ::Tilt::Template

    def self.engine_initialized?
      defined? ::WLang
    end

    def initialize_engine
      require_template_library('wlang')
    end

    protected

      def dialect
        options[:dialect] || WLang::Html
      end

      def prepare
        @engine = dialect.compile(data)
      end

      def evaluate(scope, locals, &block)
        @engine.render Scope.coerce(scope).push(locals)
      end

  end
  register WLangTemplate, 'wlang'
end