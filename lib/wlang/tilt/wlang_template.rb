module Tilt
  class WLangTemplate < ::Tilt::Template

    def self.engine_initialized?
      defined? ::WLang
    end

    def initialize_engine
      require_template_library('wlang')
    end

    protected

      def prepare
        @engine = WLang::Template.new(data, options)
      end

      def evaluate(scope, locals, &block)
        locals[:yield] = block if block
        @engine.render WLang::Scope.chain([scope, locals])
      end

  end
  register WLangTemplate, 'wlang'
end