#
# Buffering ruleset, providing special tags to load/instantiate accessible files
# and outputting instantiation results in other files. 
#
# For an overview of this ruleset, see the wlang {specification file}[link://files/specification.html].
#
module WLang::RuleSet::Buffering
  
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {'<<' => :input, '>>' => :output}
  
  # Rule implementation of <tt><<{wlang/uri}</tt>
  def self.input(parser, offset)
    uri, reached = parser.parse(offset, "wlang/uri")
    file = parser.template.file_resolve(uri, true)
    [File.read(file), reached]
  end
  
  # Rule implementation of <tt>>>{wlang/uri}</tt>
  def self.output(parser, offset)
    uri, reached = parser.parse(offset, "wlang/uri")
    file = parser.template.file_resolve(uri, false)
    #raise "Unable to write file #{file}" unless File.writable?(file)
    File.open(file, "w") do |file|
      text, reached = parser.parse_block(reached, nil, file)
    end
    ["", reached]
  end
    
end # module WLang::RuleSet::Buffering