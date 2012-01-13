require 'temple/mixins/dispatcher'
module WLang
  class Engine < Temple::Engine
    use WLang::Parser
    use WLang::Compiler
    use WLang::Generator
  end # class Engine
end # module WLang