module WLang
  class RuleSet

    #
    # Imperative ruleset, providing special tags to iterate and instantiate 
    # conditionaly. 
    #
    # For an overview of this ruleset, see the wlang {specification file}[link://files/specification.html].
    #
    module Imperative
      U=WLang::RuleSet::Utils

      # Regular expression for #1 in <tt>*{wlang/hosted}{...}</tt>
      EACH_REGEXP = /^([^\s]+)((\s+(using\s+([_a-z]+)))?(\s+(as\s+([a-z]+(,\s+[a-z]+)*)))?)?$/
      #               1       23   4        5           6   7     8
      #               1       2                         3   4     5
      
      # Default mapping between tag symbols and methods
      DEFAULT_RULESET = {'?' => :conditional, '*' => :enumeration}
  
      #
      # Conditional as <tt>?{wlang/hosted}{...}{...}</tt>
      #
      # (third block is optional) Instantiates #1, looking for an expression in the 
      # hosting language. Evaluates it, looking for a boolean value (according to 
      # boolean semantics of the hosting language). If true, instantiates #2, 
      # otherwise instantiates #3 if present.
      #
      def self.conditional(parser, offset)
        expression, reached = parser.parse(offset, "wlang/ruby")
        value = parser.evaluate(expression)
        if value
          then_block, reached = parser.parse_block(reached)
          if parser.has_block?(reached)
            else_block, reached = parser.parse_block(reached, "wlang/dummy")
          end          
          [then_block, reached]
        else
          then_block, reached = parser.parse_block(reached, "wlang/dummy")
          else_block = ""
          if parser.has_block?(reached)
            else_block, reached = parser.parse_block(reached)
          end          
          [else_block, reached]
        end
      end

      # Install args on the parser
      def self.merge_each_args(names, args)
        hash = {}
        size = names.length>args.length ? args.length : names.length
        0.upto(size-1) do |i|
          hash[names[i]] = args[i]
        end
        hash
      end
  
      #
      # Enumeration as <tt>*{wlang/hosted using each as x}{...}{...}</tt>
      #
      # (third block is optional) Instantiates #1, looking for an expression in the 
      # hosting language. Evaluates it, looking for an enumerable. Iterates all its 
      # elements, instanciating #2 for each of them (the iterated value is set under 
      # name x in the scope). If #3 is present, it is instantiated between elements.
      #
      def self.enumeration(parser, offset)
        expression, reached = parser.parse(offset, "wlang/ruby")
    
        # decode 'wlang/hosted using each as x' expression
        hash = U.expr(:no_space,
                      ["using", :var, false],
                      ["as", :multi_as, false]).decode(expression, parser)
        hash[:using] = "each" unless hash[:using]
        hash[:as] = [] unless hash[:as]
        parser.syntax_error(offset, "invalid loop expression '#{expression}'") if hash.nil?
    
        # evaluate 'wlang/hosted' sub-expression
        value = hash[:no_space]
        if value.nil? or (value.respond_to?(:empty?) and value.empty?)
          expression, reached = parser.parse_block(reached, "wlang/dummy")
          expression, reached = parser.parse_block(reached, "wlang/dummy") if parser.has_block?(reached)
          ["",reached]
        else
          raise "Enumerated value #{value} does not respond to #{hash[:using]}"\
            unless value.respond_to?(hash[:using])

          # some variables
          iterator, names = hash[:using].to_sym, hash[:as]
          buffer = parser.factor_buffer
          
          # wlang start index of each block
          block2, block3, theend = reached, nil, nil # *{}{block2}{block3}theend
          first = true
      
          # iterate now
          value.send iterator do |*args|
            if not(first) and parser.has_block?(block3)
              # parse #3, positioned at reached after that
              parsed, theend = parser.parse_block(block3)
              parser.append_buffer(buffer, parsed, true)
            end
        
            # install arguments and parse block2, positioned at block3 
            parser.context_push(merge_each_args(names, args))
            parsed, block3 = parser.parse_block(block2)
            parser.append_buffer(buffer, parsed, true)
            parser.context_pop
            first = false
          end
      
          # Singleton array special case
          unless theend
            if parser.has_block?(block3)
              parsed, theend = parser.parse_block(block3, "wlang/dummy")
            else
              theend = block3
            end
          end
          [buffer, theend]
        end
    
      end
      
    end  # module Imperative

  end
end