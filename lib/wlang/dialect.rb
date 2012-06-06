module WLang
  class Dialect

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
        return source if Template===source
        Template.new source, :dialect => self
      end

      def render(source, scope = {}, buffer = "")
        compile(source).call(scope, buffer)
      end

      # tag installation and dispatching

      # Install a new tag on the dialect for `symbols`.
      #
      # Optional `dialects` can be passed if dialect modulation needs to occur for some
      # blocks. The source code of the tag can either be passed as a `method` Symbol or
      # as a block.
      #
      # Examples:
      #
      #   # A simple tag with explicit code as a block
      #   tag('$') do |buf,fn| ... end
      #
      #   # A simple tag, reusing a method (better for testing the method easily)
      #   tag('$', :some_existing_method)
      #
      #   # Specifying that the first block of #{...}{...} has to be parsed in the same
      #   # dialect whereas the second has to be parsed in the dummy one.
      #   tag('#', [self, WLang::Dummy], ::some_existing_method)
      #
      def tag(symbols, dialects = nil, method = nil, &block)
        if block
          tag(symbols, dialects, block)
        else
          dialects, method = nil, dialects if method.nil?
          define_tag_method(symbols, dialects, method)
        end
      end

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

    # meta information

    # Returns the dialects used to parse the blocks associated with `symbols`, as
    # previously installed by `define_tag_method`.
    def dialects_for(symbols)
      info = self.class.tag_dispatching_name(symbols, "_diatag")
      raise ArgumentError, "No tag for #{symbols}" unless respond_to?(info)
      send(info)
    end

    # rendering

    # Renders `fn` to a `buffer`, optionally extending the current scope.
    #
    # `fn` can either be a String (immediately pushed on the buffer), a Proc (taken as a
    # tag block to render further), or a Template (taken as a partial to render in the
    # current scope).
    #
    # Is `scope` is specified, the current scope is first branched to use to new one in
    # priority, then rendering applies and the newly created scope if then poped.
    #
    # Returns the buffer.
    #
    def render(fn, scope = nil, buffer = "")
      if scope.nil?
        case fn
        when String
          buffer << fn
        when Proc
          fn.call(self, buffer)
        when Template
          fn.call(@scope, buffer)
        else
          raise ArgumentError, "Unable to render `#{fn}`"
        end
        buffer
      else
        with_scope(scope){ render(fn, nil, buffer) }
      end
    end

    # evaluation

    # Returns the current rendering scope.
    def scope
      @scope ||= Scope.root
    end

    # Yields the block with a scope branched with a sub-scope `x`.
    def with_scope(x)
      @scope = scope.push(x)
      res    = yield
      @scope = scope.pop
      res
    end

    # Evaluates `expr` in the current scope. `expr` can be either
    #
    # * a Symbol or a String, taken as a dot expression to evaluate
    # * a Proc or a Template, first rendered and then evaluated
    #
    # Evaluation is delegated to the scope (@see Scope#evaluate) and the result returned
    # by this method.
    #
    def evaluate(expr, *default)
      case expr
      when Symbol, String
        catch(:fail) do
          return scope.evaluate(expr, *default)
        end
        raise NameError, "Unable to find `#{expr}`"
      else
        evaluate(render(expr), *default)
      end
    end

  end # class Dialect
end # module WLang
