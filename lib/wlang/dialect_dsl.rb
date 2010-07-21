module WLang
  class Dialect
    
    #
    # Installs the Domain Specific Language allowing to create new dialects easily.
    # Below is a self-explaining example on how to use it.
    #
    #   #
    #   # Starts a new _wlang_ dialect that will have children.
    #   # 
    #   WLang::dialect("wlang") do
    #
    #     #
    #     # Starts a _wlang/xhtml_ dialect that will be attached to .wtpl and .whtml
    #     # file extensions.
    #     #
    #     dialect("xhtml", ".wtpl", ".whtm") do 
    #
    #       # If your dialect needs external gems or files, use ruby_require instead
    #       # of built-in require: it will allow avoiding all users to have required 
    #       # dependencies for dialects they don't use.
    #       ruby_require "somegem", "wlang/rulesets/basic_ruleset", "wlang/dialects/coderay_dialect" do
    #
    #         # RuleSet defined as Ruby modules can be installed using _rules_.
    #         # Here: we automatically add the standard Basic ruleset to our dialect.
    #         rules WLang::RuleSet::Basic
    #
    #         # You can also install inline rules if they are not designed to be 
    #         # reusable by others.
    #         # Here, we add a #{...} rule that replaces all spaces by '#' symbols
    #         # For rule implementation, see Rule class.
    #         rule "#" do |parser, offset|
    #           text, reached = parser.parse(offset)
    #           text = text.gsub(/\s/, '#')
    #           [text, reached]
    #         end 
    #
    #         # Encoders can be installed the same way(s)
    #         # Here: we install all coderay encoders defined in a module
    #         encoders WLang::EncoderSet::CodeRay
    #
    #         # And inline encoders can be installed as well
    #         # Encoder below will be allowed as ^{wlang/xhtml/upcase}{...} for example
    #         encoder 'upcase' do |src, options|
    #           src.upcase
    #         end
    #
    #       end # ruby_require
    #
    #     end # wlang/xhtml dialect
    # 
    #   end # wlang dialect
    #
    class DSL
  
      # Initializes dsl with a real dialect instance
      def initialize(dialect)
        raise(ArgumentError, "Dialect expected") unless WLang::Dialect===dialect
        @dialect = dialect
      end
  
      #
      # Handles dialect dependencies: all _src_ dependencies will be correctly loaded 
      # at dialect building time (dialect are lazy loaded to avoid having all users 
      # to have all dependencies of standard dialects).
      #
      # This method should always be used instead of _require_. It takes a block that
      # will be executed at building-time. Any code with dependency usage should be
      # part of the block ! 
      #
      def ruby_require(*src) end
  
      #
      # Starts definition of a sub-dialect of the current one. _name_ is not allowed
      # to be a qualified name. _extensions_ allows wlang to automatically infer
      # dialects used by template files. A block is expected and should contain
      # sub-dialect installation.  
      #
      def dialect(name, *extensions, &block)
        child = WLang::Dialect.new(name, @dialect, &block)
        extensions.each do |ext|
          ext = ('.' << ext) unless ext[0,1]=='.'
          WLang::FILE_EXTENSIONS[ext] = child.qualified_name
        end
        @dialect.add_child_dialect(name, child)
      end
  
      #
      # Sets a transformer to use at end of generation time.
      #
      def post_transform(transformer = nil, &block) end
  
      #
      # Adds a dialect encoder under _name_. Encoder's code is provided by the block.
      # This block should always take <tt>|src, options|</tt> arguments: _src_ is
      # the string to encode, _options_ is a Hash instance containing additional 
      # encoding options.
      #
      def encoder(name, &block) end
  
      #
      # Adds reusable encoders defined in a Ruby module. _mod_ must be a Module instance.
      # If _pairs_ is ommitted (nil), all encoders of the module are added, under their
      # standard names (see DEFAULT_ENCODERS under WLang::EncoderSet::XHtml for example).
      # Otherwise, _pairs_ is expected to be a Hash providing a mapping between encoder 
      # names and _mod_ methods (whose names are given by ruby symbols).  
      #
      def encoders(mod, pairs=nil) end
  
      #  
      # Maps an inline rule with some tag symbols. _symbol_ must be ASCII symbols 
      # allowed by the wlang specification. The rule implementation is provided by
      # the block. see Rule class about rule implementation. 
      # 
      def rule(symbol, &block) end

      #  
      # Adds reusable rules defined in a Ruby module. _mod_ must be a Module instance.
      # If _pairs_ is ommitted (nil), all rules of the module are added, under their
      # standard tag symbols (see DEFAULT_RULESET under WLang::RuleSet::Basic for example).
      # Otherwise, _pairs_ is expected to be a Hash providing a mapping between tag 
      # symbols and _mod_ methods (whose names are given by ruby symbols).  
      #
      def rules(mod, pairs=nil) end
  
      #  
      # Request wlang to associate _args_ files extensions with this dialect. File 
      # extensions may also be installed at construction (see dialect).
      #
      def extensions(*args)
        args.each do |ext|
          ext = ('.' << ext) unless ext[0,1]=='.'
          WLang::FILE_EXTENSIONS[ext] = @dialect.qualified_name
        end
      end
      alias :extension :extensions 
  
    end # class DSL
  
  end
end