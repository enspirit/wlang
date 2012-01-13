module WLang
  Citrus.load(File.expand_path('../grammar', __FILE__))
  class Parser
    
    def initialize(options = {})
    end

    def call(input)
      WLang::Grammar.parse(input).value
    end

  end # class Engine
end # module WLang