require 'wlang/dialect/evaluation'
require 'wlang/dialect/tags'
module WLang
  class Dialect
    include Dialect::Evaluation
    include Dialect::Tags

    class << self

      # facade

      def factor(options = {})
        new(default_options.merge(options))
      end

      def default_options(options = {})
        @default_options ||= (superclass.default_options.dup rescue {})
        @default_options.merge!(options)
      end

      def compiler(options = {})
        factor(options).compiler
      end

      def compile(source, options = {})
        compiler(options).compile(source)
      end

      def to_ruby_code(source, options = {})
        compiler(options).to_ruby_code(source)
      end

      def render(source, scope = {}, buffer = "")
        compile(source).call(scope, buffer)
      end

      # dispatching

      # Returns the dispatching method name for a given tag symbol and optional prefix
      # (defaults to '_tag').
      #
      # Example:
      #
      #   Dialect.tag_dispatching_name('!$')
      #   # => :_tag_33_36
      #
      #   Dialect.tag_dispatching_name('!$', "my_prefix")
      #   # => :my_prefix_33_36
      #
      def tag_dispatching_name(symbols, prefix = "_tag")
        symbols = symbols.chars unless symbols.is_a?(Array)
        chars   = symbols.map{|s| s.ord}.join("_")
        "#{prefix}_#{chars}".to_sym
      end

      # Binds two methods for the given `symbols`:
      #
      # 1) _tag_xx_yy that executes `code`
      # 2) _diatag_xx_yy that returns the dialect information of the tag blocks.
      #
      # `code` can either be a Symbol (existing method) or a Proc (some explicit code).
      #
      def define_tag_method(symbols, dialects, code)
        rulename = tag_dispatching_name(symbols, "_tag")
        case code
        when Symbol
          module_eval %Q{ alias :#{rulename} #{code} }
        when Proc
          define_method(rulename, code)
        else
          raise "Unable to use #{code} for a tag"
        end
        dialects_info_name = tag_dispatching_name(symbols, "_diatag")
        define_method(dialects_info_name) do dialects end
      end

    end # class methods

    default_options :braces      => WLang::BRACES,
                    :autospacing => false

    attr_reader :options
    def braces; options[:braces]; end

    attr_reader :compiler

    def initialize(options = {})
      @options  = options
      @compiler = WLang::Compiler.new(self)
    end

    # dispatching

    # Returns the dialects used to parse the blocks associated with `symbols`, as
    # previously installed by `define_tag_method`.
    def dialects_for(symbols)
      info = self.class.tag_dispatching_name(symbols, "_diatag")
      raise ArgumentError, "No tag for #{symbols}" unless respond_to?(info)
      send(info)
    end

  end # class Dialect
end # module WLang
