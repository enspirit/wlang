#
# Buffering ruleset, providing special tags to load/instantiate accessible files
# and outputting instantiation results in other files. 
#
# For an overview of this ruleset, see the wlang {specification file}[link://files/specification.html].
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