require 'wlang/basic_object'

#
# Execution context of the Parser for <tt>!{wlang/hosted}</tt> and associated 
# tags. The execution context defines the semantics of executed code in those 
# tags as well as utilities to handle semantical scoping.
#
# TODO: define context and scoping semantics more precisely and extend the 
# documentation
#
class WLang::Parser::Context 
  
  # Common methods of scope instances
  class Scope < WLang::BasicObject
    attr_accessor :__parent
    
  end # module Scope
  
  # Hash scoping mechanism
  class HashScope < Scope 
    
    # Decorates a hash as a scope.
    def initialize(hash={})
      @__hash = hash
      @__parent = nil
    end
    
    # Tries to convert found value to a given variable.
    def method_missing(symbol, *args)
      varname = symbol.to_s
      if @__hash.has_key?(varname) 
        @__hash[varname]
      elsif @__parent
        @__parent.method_missing(symbol, *args)
      else
        nil
      end
    end
    
    # See Scope#__evaluate
    def __evaluate(expr)
      self.instance_eval(expr)
    end
    
    # See Scope#__define
    def __define(key, value); 
      @__hash[key]=value; 
    end
    
  end # class HashScope
  
  # Creates an empty context on an init scope object.
  def initialize(init=nil)
    @current_scope = HashScope.new
    push(init) unless init.nil?
  end
  
  # Evaluates a ruby expression on the current context.
  def evaluate(expression)
    @current_scope.__evaluate(expression)
  end
  
  # Pushes a new scope instance.
  def push(who={})
    who = to_scope(who)
    who.__parent = @current_scope
    @current_scope = who
  end
  
  # Pops the last added scope.
  def pop
    parent = @current_scope.__parent
    raise "Bad scope usage, nothing to pop" if parent.nil?
    @current_scope = parent
  end
  
  # Defines a variable/value mapping in the current scope.
  def define(key, value)
    @current_scope.__define(key,value)
  end
  
  # Converts a given instance to a Scope.
  def to_scope(who)
    return who if Scope===who
    return who.to_wlang_scope if who.respond_to?(:to_wlang_scope)
    return HashScope.new(who) if Hash===who
    raise(ArgumentError,"Unable to convert #{who} to a scope")
  end
  
end # class Context
