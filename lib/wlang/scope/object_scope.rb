module WLang
  class Scope
    class ObjectScope < Scope

      def fetch(k, &blk)
        return subject if k == :self
        s = subject
        if s.respond_to?(k)
          s.send(k)
        else
          parent.fetch(k, &blk)
        end
      rescue NameError
        parent.fetch(k, &blk)
      end

    end # class ProxyScope
  end # class Scope
end # module WLang
