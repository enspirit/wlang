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
    
        # decode expression
        decoded = U.expr(:uri,
                      ["using", :using, false],
                      ["with",  :with, false]).decode(uri, parser)
        parser.syntax_error(offset) if decoded.nil?
        
        # handle wit
        context = nil
        if decoded[:using]
          raise "<<+ does not support multiple with for now." if decoded[:using].size != 1
          context = decoded[:using][0]
          raise "Unexpected nil context when duplicated" if context.nil?
        else
          context = {}
        end
        
        # handle using now
        if decoded[:with]
          case context
            when WLang::Parser::Context::HashScope
              context = context.__branch(decoded[:with]) 
            when Hash
              context = context.merge(decoded[:with])
            else
              raise "Unexpected context #{context}"
          end
        end
        
        file = parser.template.file_resolve(decoded[:uri], false)
        if File.file?(file) and File.readable?(file)
          instantiated = WLang::file_instantiate(file, context)
          [instantiated, reached]
        else
          text = parser.parse(offset, "wlang/dummy")[0]
          parser.error(offset, "unable to apply input-inclusion rule <<+{#{text}}, not a file or not readable (#{file})")
        end
      end
  

    end # module Buffering
    
  end
end