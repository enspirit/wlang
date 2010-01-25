require 'delegate'
module WLang
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