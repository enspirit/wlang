#
# Buffering ruleset, providing special tags to load/instantiate accessible files
# and outputting instantiation results in other files. This ruleset provides the
# following tags and associated rules: 
#
# [<<{wlang/uri}] (*input*) Instanciates #1, looking for an URI. Opens it and 
#                 returns its contents as replacement value.
#
module WLang::RuleSet::Buffering
  
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {'<<' => :input}
  
  # Rule implementation of <tt><<{wlang/uri}</tt>
  def self.input(parser, offset)
    uri, reached = parser.parse(offset, "wlang/active-string")
    file = parser.template.file_resolve(uri, true)
    [File.read(file), reached]
  end
    
end # module WLang::RuleSet::Buffering