require 'wlang/rulesets/ruleset_utils'
require 'fileutils'

module WLang
  class RuleSet
    
    #
    # Buffering ruleset, providing special tags to load/instantiate accessible files
    # and outputting instantiation results in other files. 
    #
    # For an overview of this ruleset, see the wlang {specification file}[link://files/specification.html].
    #
    module Buffering
      U=WLang::RuleSet::Utils
  
      # Default mapping between tag symbols and methods
      DEFAULT_RULESET = {'<<' => :input, '>>' => :output,
                         '<<=' => :data_assignment, '<<+' => :input_inclusion}
  
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
        dir = File.dirname(file)
        FileUtils.mkdir_p(dir) unless File.exists?(dir)
        File.open(file, "w") do |file|
          text, reached = parser.parse_block(reached, nil, file)
        end
        ["", reached]
      end
    
      # Rule implementation of <<={wlang/uri as x}{...}
      def self.data_assignment(parser, offset)
        uri, reached = parser.parse(offset, "wlang/uri")
    
        # decode expression
        decoded = U.decode_uri_as(uri)
        parser.syntax_error(offset) if decoded.nil?
    
        file = parser.template.file_resolve(decoded[:uri], true)
        data = WLang::load_data(file)
    
        # handle two different cases
        if parser.has_block?(reached)
          parser.context_push(decoded[:variable] => data)
          text, reached = parser.parse_block(reached)
          parser.context_pop
          [text, reached]
        else
          parser.context_define(decoded[:variable], data)
          ["", reached]
        end
      end

      # Rule implementation of <<+{wlang/uri with ...}
      def self.input_inclusion(parser, offset)
        uri, reached = parser.parse(offset, "wlang/uri")
    
        # decode expression
        decoded = U.expr(:uri,
                      ["using", :using, false],
                      ["with",  :with, false]).decode(uri, parser)
        parser.syntax_error(offset) if decoded.nil?
        
        # handle wit
        if decoded[:using]
          raise "<<+ does not support multiple with for now." if decoded[:using].size != 1
          context = decoded[:using][0].dup
        else
          context = {}
        end
        
        # handle using now
        context = context.merge(decoded[:with]) if decoded[:with]
    
        file = parser.template.file_resolve(decoded[:uri], true)
        instantiated = WLang::file_instantiate(file, context)
        [instantiated, reached]
      end
  

    end # module Buffering
    
  end
end