require 'wlang/basic_object'
module WLang
  class Parser
    
    #
    # Execution context of the Parser for <tt>!{wlang/hosted}</tt> and associated 
    # tags. The execution context defines the semantics of executed code in those 
    # tags as well as utilities to handle semantical scoping.
    #
    # TODO: define context and scoping semantics more precisely and extend the 
    # documentation
    #
    class Context 
  
      # Common methods of scope instances
      class Scope < WLang::BasicObject
        attr_accessor :__parent
    
      end # module Scope
  
      # Hash scoping mechanism
      class HashScope < Scope 
        attr_reader :__hash
    
        # Decorates a hash as a scope.
        def initialize(hash={}, parent=nil)
          @__hash = hash
          @__parent = parent
        end
        
        def nil?
          false
        end
        
        def dup
          HashScope.new(@__hash.dup, @__parent)
        end
        
        def __branch(other)
          HashScope.new(other, self)
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
    
        # Returns underlying object
        def __underlying
          return @__hash
        end
    
        # See Scope#__evaluate
        def __evaluate(expr)
          self.instance_eval(expr)
        end
    
        # See Scope#__define
        def __define(key, value); 
          @__hash[key]=value; 
        end
    
        def /(symb)
          s = symb.to_s
          if  @__hash.has_key?(s)
            return WLang::Parser::Context.to_scope(@__hash[s])
          else 
            return nil
          end
        end
        
        def inspect
          "#{__underlying.inspect} with parent #{@__parent.inspect}"  
        end
    
      end # class HashScope
  
      # Creates an empty context on an init scope object.
      def initialize(init=nil)
        if (Scope===init)
          @current_scope = init
        else 
          @current_scope = HashScope.new
          push(init) unless init.nil?
        end
      end
  
      # Evaluates a ruby expression on the current context.
      def evaluate(expression)
        if "self" == expression.strip
          @current_scope
        elsif /[a-z]+(\/[a-z]+)+/ =~ expression
          expression = ("self/" + expression).gsub(/\//,"/:")
          expr = @current_scope.__evaluate(expression)
          expr = expr.__underlying if Scope===expr
          return expr
        else
          @current_scope.__evaluate(expression)  
        end
      rescue Exception => ex
        puts "Warning, some wlang exception when evaluating the expression\n#{expression}"
        puts "Message was: #{ex.message}"
        puts ex.backtrace.join("\n")
        puts "Current scope was:\n"
        puts @current_scope.__underlying.inspect
        return nil
      end
  
      # Pushes a new scope instance.
      def push(who={})
        who = WLang::Parser::Context.to_scope(who)
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
      def self.to_scope(who)
        return who if Scope===who
        return who.to_wlang_scope if who.respond_to?(:to_wlang_scope)
        return HashScope.new(who) if Hash===who
        return who
      end
  
    end # class Context

  end
end