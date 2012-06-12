module WLang
  class Source

    attr_reader :subject
    attr_reader :template

    def initialize(subject, template = nil)
      @subject  = subject
      @template = template
      @locals   = {}
    end

    def path
      find_on_subject(:path, :to_path)
    end
    alias :to_path :path

    def locals
      @locals
    end

    def raw_content
      find_on_subject(:read, :to_str){
        raise ArgumentError, "Invalid template source `#{subject}`"
      }
    end

    def template_content
      raw_content
    end

    def to_str
      template_content
    end
    alias :to_s :to_str

    def with_front_matter(enabled = true)
      enabled ? FrontMatter.new(self, template) : self
    end

    private

      def find_on_subject(*methods)
        s = subject
        if meth = methods.find{|m| s.respond_to?(m) }
          subject.send(meth)
        elsif block_given?
          yield
        else
          nil
        end
      end

  end # class Source
end # module WLang
require 'wlang/source/front_matter'