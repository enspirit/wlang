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
        file = parser.template.file_resolve(uri, false)
        if File.file?(file) and File.readable?(file)
          [File.read(file), reached]
        else
          text = parser.parse(offset, "wlang/dummy")[0]
          parser.error(offset, "unable to apply input rule <<{#{text}}, not a file or not readable (#{file})")
        end
      end
  
      # Rule implementation of <tt>>>{wlang/uri}</tt>
      def self.output(parser, offset)
        uri, reached = parser.parse(offset, "wlang/uri")
        file = parser.template.file_resolve(uri, false)
        dir = File.dirname(file)
        if File.writable?(dir) or not(File.exists?(dir))
          FileUtils.mkdir_p(dir) unless File.exists?(dir)
          File.open(file, "w") do |file|
            text, reached = parser.parse_block(reached, nil, file)
          end
          ["", reached]
        else
          text = parser.parse(offset, "wlang/dummy")[0]
          parser.error(offset, "unable to apply output rule >>{#{text}}, not a writable directory (#{file})")
        end
      end
    
      # Rule implementation of <<={wlang/uri as x}{...}
      def self.data_assignment(parser, offset)
        uri, reached = parser.parse(offset, "wlang/uri")
    
        # decode expression
        decoded = U.decode_uri_as(uri)
        parser.syntax_error(offset) if decoded.nil?
    
        file = parser.template.file_resolve(decoded[:uri], false)
        if File.file?(file) and File.readable?(file)
          data = WLang::load_data(file)
    
          # handle two different cases
          if parser.has_block?(reached)
            parser.branch_scope(decoded[:variable] => data) {
              parser.parse_block(reached)
            }
          else
            parser.scope_define(decoded[:variable], data)
            ["", reached]
          end
        else
          text = parser.parse(offset, "wlang/dummy")[0]
          parser.error(offset, "unable to apply data-assignment rule <<={#{text}} (#{file}), not a file or not readable (#{file})")
        end
      end

      # Rule implementation of <<+{wlang/uri with ...}
      def self.input_inclusion(parser, offset)
        uri, reached = parser.parse(offset, "wlang/uri")
    
        # decode the expression
        decoded = U.expr(:uri,
                      ["share", :share, false],
                      ["using", :using, false],
                      ["with",  :with, false]).decode(uri, parser)
        parser.syntax_error(offset) if decoded.nil?
        
        # Look for share and context
        shared  = decoded[:share].nil? ? :root : decoded[:share]
        context = U.context_from_using_and_with(decoded)
        
        # Resolve the file by delegation to the parser
        file = parser.file_resolve(decoded[:uri])
        
        # Go for it
        if File.file?(file) and File.readable?(file)
          parser.branch(:template => parser.file_template(file),
                        :offset   => 0,
                        :shared   => shared,
                        :scope    => context) {
            instantiated, forget = parser.instantiate
            [instantiated, reached]
          }
        else
          text = parser.parse(offset, "wlang/dummy")[0]
          parser.error(offset, "unable to apply input-inclusion rule <<+{#{text}}, not a file or not readable (#{file})")
        end
      end
  

    end # module Buffering
    
  end
end