require 'delegate'
module WLang
  class HashScope < DelegateClass(Hash)
    
    # The parent scope, or nil if no such parent
    attr_reader :parent
    
    # Creates a scope instance with a parent and initial 
    # values through a Hash
    def initialize(parent, initials = {})
      @parent = parent
      super(initials)
    end
    
  end # class HashScope
end # module WLang