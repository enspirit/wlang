module WLang
  class Parser
    # 
    # Encapsulates all state information of a WLang parser
    #
    class State
      
      # The attached parser
      attr_accessor :parser
      
      # The parent state
      attr_accessor :parent
      
      # The current hosted language
      attr_accessor :hosted
      
      # The current template
      attr_accessor :template
      
      # The current dialect
      attr_accessor :dialect
      
      # The current offset in template's source code
      attr_accessor :offset
      
      # The current scope
      attr_accessor :scope
      
      # The current output buffer
      attr_accessor :buffer
      
      # Creates a new state instance for a given parser and optional
      # parent.
      def initialize(parser, parent = nil)
        @parser, @parent = parser, parent
      end
      
      # Checks internals
      def check
        raise "WLang::Parser::State fatal: missing parser" unless parser
        raise "WLang::Parser::State fatal: missing hosted" unless hosted
        raise "WLang::Parser::State fatal: missing template" unless template
        raise "WLang::Parser::State fatal: missing dialect" unless dialect
        raise "WLang::Parser::State fatal: missing offset" unless offset
        raise "WLang::Parser::State fatal: missing scope" unless scope
        raise "WLang::Parser::State fatal: missing buffer" unless buffer
        self
      end
      
      #
      # Branches this state.
      #
      # Branching allows creating a child parser state of this one. Options are:
      # - :hosted     => a new hosted language
      # - :template   => a new template
      # - :dialect    => a new dialect
      # - :offset     => a new offset in the template
      # - :shared     => :all, :root or :none (which scoping should be shared)
      # - :scope      => a Hash of new pairing to push on the new scope
      # - :buffer     => a new output buffer to use
      #
      def branch(opts = {})
        child = State.new(parser, self)
        child.hosted    = opts[:hosted]    || hosted
        child.template  = opts[:template]  || template
        child.dialect   = opts[:dialect]   || child.template.dialect
        child.offset    = opts[:offset]    || offset 
        child.buffer    = opts[:buffer]    || child.dialect.factor_buffer
        child.scope     = case opts[:shared]
          when :all, NilClass
            scope.branch(opts[:scope])
          when :root
            scope.root.branch(opts[:scope])
          when :none
            ::WLang::HashScope.new(opts[:scope])
          else
            raise ArgumentError, "Invalid ParserState.branch option :shared #{opts[:shared]}" 
        end
        child.check
      end
      
      # Returns a friendly location for this parser state
      def where
        template ? template.where(offset) : "Source template tree"
      end
      
      # Returns a friendly wlang backtrace as an array
      def backtrace
        parent ? (parent.backtrace << where) : [where]
      end
      
    end # class State
  end # class Parser
end # module WLang