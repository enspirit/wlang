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

    def initialize(__obj__)
      @__obj__ = __obj__
    end

  end # class Scope

  class HashScope < Scope

    def method_missing(name, *args, &block)
      if args.empty? and !block
        if @__obj__.has_key?(name)
          __(@__obj__[name])
        elsif @__obj__.has_key?(name.to_s)
          __(@__obj__[name.to_s])
        else
          super
        end
      elsif @__obj__.respond_to?(name)
        @__obj__.send(name, *args, &block)
      end
    end

    def respond_to?(name)
      @__obj__.respond_to?(name) or
      @__obj__.has_key?(name) or
      @__obj__.has_key?(name.to_s)
    end

    def [](name)
      __(@__obj__[name])
    end

  end # class HashScope

end # module WLang
