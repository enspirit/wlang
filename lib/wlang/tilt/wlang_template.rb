module Tilt
  class WLangTemplate < ::Tilt::Template

    class << self

      def engine_initialized?
        defined? ::WLang
      end

      def with_options(options)
        Class.new(WLangTemplate).tap{|c| c.default_options = options }
      end

      def default_options=(options)
        @default_options = options
      end

      def default_options
        (superclass.default_options rescue {}).merge(@default_options || {})
      end

    end

    def initialize_engine
      require_template_library('wlang')
    end

    protected

      def prepare
        opts = self.class.default_options.merge(self.options)
        opts.merge!(:path => file) if file
        @engine = WLang::Template.new(data, opts)
      end

      def evaluate(scope, locals, &block)
        locals[:yield] = block if block
        @engine.render WLang::Scope.chain([scope, locals])
      end

  end
  register WLangTemplate, 'wlang'
end