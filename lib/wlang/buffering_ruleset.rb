module WLang
class RuleSet
  
  # Basic ruleset
  module Buffering
    
    # Default mapping between tag symbols and methods
    DEFAULT_RULESET = {'<<' => :input}
    
    #
    # Input as <tt><<{wlang/uri}</tt>
    #
    # Instanciates #1, looking for an uri. Returns the text content of the found 
    # uri (#1).
    #
    def self.input(parser, offset)
      uri, reached = parser.parse(offset, "wlang/active-string")
      file = parser.template.file_resolve(uri, true)
      [File.read(file), reached]
    end
    
  end  # module Basic
  
end # class RuleSet
end # module WLang