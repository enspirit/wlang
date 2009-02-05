module WLang
class Parser
  
#
# Parsing context.
#
class Context
  
  # Common methods of scope instances
  module Scope
    attr_accessor :parent
    
  end # module Scope
  
  # Hash scoping mechanism
  class HashScope
    include Scope
    
    # Decorates a hash as a scope
    def initialize(hash={})
      @hash = hash
      @parent = nil
    end
    
    # Tries to convert found value to a given variable
    def method_missing(symbol, *args)
      varname = symbol.to_s
      if @hash.has_key?(varname) 
        @hash[varname]
      elsif @parent
        @parent.method_missing(symbol, *args)
      else
        nil
      end
    end
    
    # Delegated to hash
    def [](key); @hash[key]; end
    
    # Delegated to hash
    def []=(key, value); @hash[key]=value; end
    
  end # class HashScope
  
  # Creates an empty context
  def initialize(init=nil)
    @current_scope = HashScope.new
    push(init) unless init.nil?
  end
  
  # Evaluates a ruby expression on the current context.
  def evaluate(expression)
    @current_scope.instance_eval(expression)
  end
  
  # Pushes a new scope instance
  def push(who={})
    if Hash===who
      push HashScope.new(who)
    elsif who.is_a?(Scope)
      who.parent = @current_scope
      @current_scope = who
    else 
      raise(ArgumentError,"Unable to convert #{who} to a scope")
    end
  end
  
  # Pops the last added scope
  def pop
    parent = @current_scope.parent
    raise "Bad scope usage, nothing to pop" if parent.nil?
    @current_scope = parent
  end
  
  # Adds a variable in the current scope
  def [](key, value)
    @current_scope[key] = value
  end
  
end # class Context
  
end # class Parser
end # module WLang