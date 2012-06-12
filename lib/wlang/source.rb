module WLang
  class Source

    attr_reader :subject
    attr_reader :template

    def initialize(subject, template = nil)
      @subject  = subject
      @template = template
    end

    def locals
      {}
    end

    def template_content
      ""
    end

    def to_str
      template_content
    end
    alias :to_s :to_str

  end # class Source
end # module WLang
require 'wlang/source/raw'
require 'wlang/source/front_matter'