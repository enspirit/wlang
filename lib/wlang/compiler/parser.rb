module WLang
  Citrus.load(File.expand_path('../grammar', __FILE__))
  class Parser

    def initialize(options = {})
    end

    def call(input)
      return input if input.is_a?(Array)
      parser.parse(parsing_source(input)).value
    end

    private

    def parser
      WLang::Grammar
    end

    def parsing_source(input)
      input = File.read(input.to_path) if input.respond_to?(:to_path)
      input = input.to_str if input.respond_to?(:to_str)
      input
    end

  end # class Engine
end # module WLang