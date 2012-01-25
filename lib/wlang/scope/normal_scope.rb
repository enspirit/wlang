module WLang
  class Scope
    class NormalScope < Scope

      def fetch(key)
        catch :fail do
          return fetch_one_or_fail(subject, key)
        end
        parent.fetch(key)
      end

    end # class NormalScope
  end # class Scope
end # module WLang
