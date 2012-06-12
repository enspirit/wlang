module WLang
  class Source
    class Raw < Source

      def template_content
        subject = self.subject
        if to_path = looks_a_path?(subject)
          File.read(subject.send(to_path))
        elsif meth = looks_readable?(subject)
          subject.send(meth)
        else
          raise ArgumentError, "Invalid template source `#{subject}`"
        end
      end

      private

        def looks_a_path?(arg)
          [:path, :to_path].find{|m| arg.respond_to?(m)}
        end

        def looks_readable?(arg)
          [:read, :to_str].find{|m| arg.respond_to?(m)}
        end

    end
  end
end