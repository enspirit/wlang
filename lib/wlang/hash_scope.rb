require 'delegate'
module WLang
  #
  # Implements a scoping mechanism on top of a ruby hash (accessible through pairing). 
  # Such a scope mimics hashses for has_key?, [] and []= methods. A scope has an 
  # accessible parent. Scopes form a tree, the root being accessible using its 
  # natural accessor. Scope lookup (has_key? and []) uses the hierarchy to find
  # accessible variables.
  #
  # Branching a scope allows installing new variables that hide variables with the 
  # same name in the parent scope. Branching is made easy through the branch methods
  # that accepts a block, passing the child as first argument:
  #
  #   scope = HashScope.new(:name => 'wlang')
  #   puts scope[:name]    # prints 'wlang'
  #   scope.branch(:name => 'other') do |child|
  #     puts child[:name]  # prints 'other'
  #   end
  #   puts scope[:name]    # prints 'wlang'
  #
  # This branching mechanism is intended to be used to keep a current scope as instance
  # variable of a using class:
  # 
  #   # We create an initial scope at construction
  #   def initialize
  #     @scope = HashScope.new
  #   end
  #
  #   # Appends the current scope with new key/value pairs. Yields the block
  #   # with the new scope and restore the original one after that.
  #   def do_something_with_a_new_scope(hash = {})
  #     @scope = @scope.branch(:name => 'other')
  #       yield if block_given?
  #     @scope = @scope.parent
  #   end
  #
  class HashScope
    
    # The parent scope, or nil if no such parent
    attr_reader :parent
    
    # The key/value pairing inside this scope
    attr_reader :pairing
    
    # Creates a scope instance with a parent and initial 
    # pairing through a Hash
    def initialize(pairing = nil, parent = nil)
      @pairing = pairing || {}
      @parent = parent
    end
        
    # Returns the root scope
    def root
      @root ||= (parent ? parent.root : self)
    end
    
    # Checks if a key exists in this scope, delegating to
    # parent if not found and allowed
    def has_key?(key, delegate = true)
      pairing.has_key?(key) || (delegate && parent && parent.has_key?(key))
    end
    
    # Returns the value associated to a key, delegating to parent
    # if not found and allowed
    def [](key, delegate = true)
      pairing.has_key?(key) ? pairing[key] : (delegate && parent && parent[key])
    end
    
    # Associates a key to a value inside this scope
    def []=(key, value)
      pairing[key] = value
    end
    
    # Creates a new child scope and returns it. If a block is given,
    # yields the block with the child scope
    def branch(pairing = nil)
      child = HashScope.new(pairing, self)
      yield child if block_given?
      child
    end
    
  end # class HashScope
end # module WLang