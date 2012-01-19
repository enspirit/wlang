module WLang
  Citrus.load(File.expand_path('../grammar', __FILE__))
  class Parser

    def initialize(options = {})
    end

    def call(input)
      return input if input.is_a?(Array)
      input = File.read(input.to_path) if input.respond_to?(:to_path)
      input = input.to_str if input.respond_to?(:to_str)
      WLang::Grammar.parse(input).value
    end

  end # class Engine
end # module WLang