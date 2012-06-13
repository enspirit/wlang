module WLang
  class Scope
    class SinatraScope < ObjectScope

      def fetch(key, dialect = nil, unfound = nil)
        find_partial(key, subject) || super
      end

      def inspect
        "SinatraScope"
      end
      alias :to_s :inspect

    private

      def find_partial(key, app)
        views = app.settings.views
        find_files(views, key) do |file|
          if engine = Tilt[file]
            tpl = app.template_cache.fetch(file) do
              engine.new(file.to_s, 1, {})
            end
            return tpl
          end
        end
        nil
      end

      def find_files(folder, name, &bl)
        Path(folder).glob("#{name}.*").each(&bl)
      end

    end # class SinatraScope
  end # class Scope
end # module WLang
