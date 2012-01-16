module WLang

  class Scope < BasicObject

    def Scope.factor(arg)
      if arg.respond_to?(:to_hash)
        HashScope.new(arg.to_hash)
      else 
        arg
      end
    end
    def __(arg); Scope.factor(arg); end

    def initialize(context)
      @context = context
    end

  end # class Scope

  class HashScope < Scope

    def method_missing(name, *args, &block)
      if args.empty? and !block
        if @context.has_key?(name)
          __(@context[name])
        elsif @context.has_key?(name.to_s)
          __(@context[name.to_s])
        else
          super
        end
      elsif @context.respond_to?(name)
        @context.send(name, *args, &block)
      end
    end

    def respond_to?(name)
      @context.respond_to?(name) or
      @context.has_key?(name) or
      @context.has_key?(name.to_s)
    end

    def [](name)
      __(@context[name])
    end

  end # class HashScope

end # module WLang
