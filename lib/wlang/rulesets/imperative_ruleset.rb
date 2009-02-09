module WLang
class RuleSet
  
# Basic ruleset
module Imperative

  # Regular expression for #1 in <tt>*{wlang/hosted}{...}</tt>
  EACH_REGEXP = /^([^\s]+)((\s+(using\s+([_a-z]+)))?(\s+(as\s+([a-z]+(,\s+[a-z]+)*)))?)?$/
  #               1       23   4        5           6   7     8
  #               1       2                         3   4     5
      
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {'?' => :conditional, '*' => :enumeration}
  
  #
  # Conditional as <tt>?{wlang/hosted}{...}{...}</tt>
  #
  # (third block is optional) Instanciates #1, looking for an expression in the 
  # hosting language. Evaluates it, looking for a boolean value (according to 
  # boolean semantics of the hosting language). If true, instanciates #2, 
  # otherwise instanciates #3 if present.
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
  # Decodes the first block of a <tt>*{wlang/hosted}{...}</tt> and returns a 
  # Hash containing following keys: :iterated, :iterator, :names. Returns nil
  # if the expression is not correct.
  # 
  def self.decode_each(text)
    match = EACH_REGEXP.match(text)
    return nil unless match
    hash = {:iterated => match[1], :iterator => "each", :names => []}
    unless match[5].nil?
      hash[:iterator] = match[5]
    end
    unless match[8].nil?
      hash[:names] = match[8].split(/,\s+/)
    end
    return hash
  end
  
  #
  # Enumeration as <tt>*{wlang/hosted using each as x}{...}{...}</tt>
  #
  # (third block is optional) Instanciates #1, looking for an expression in the 
  # hosting language. Evaluates it, looking for an enumerable. Iterates all its 
  # elements, instanciating #2 for each of them (the iterated value is set under 
  # name x in the scope). If #3 is present, it is instanciated between elements.
  #
  def self.enumeration(parser, offset)
    expression, reached = parser.parse(offset, "wlang/ruby")
    
    # decode 'wlang/hosted using each as x' expression
    hash = decode_each(expression)
    raise "Invalid loop expression '#{expression}'" if hash.nil?
    
    # evaluate 'wlang/hosted' sub-expression
    value = parser.evaluate(hash[:iterated])
    if value.nil?
      expression, reached = parser.parse_block(reached, "wlang/dummy")
      expression, reached = parser.parse_block(reached, "wlang/dummy") if parser.has_block?(reached)
      ["",reached]
    else
      raise "Enumerated value #{value} does not respond to #{hash[:iterator]}"\
        unless value.respond_to?(hash[:iterator])

      # some variables
      iterator, names = hash[:iterator].to_sym, hash[:names]
      buffer = ""
      block2, block3, theend = reached, nil, nil # *{}{block2}{block3}
      first = true
      
      # iterate now
      value.send iterator do |*args|
        if not(first) and parser.has_block?(block3)
          # parse #3, positioned at reached after that
          parsed, theend = parser.parse_block(block3)
          buffer << parsed 
        end
        
        # install arguments and parse block2, positioned at block3 
        parser.context_push(merge_each_args(names, args))
        parsed, block3 = parser.parse_block(block2)
        buffer << parsed
        parser.context_pop
        first = false
      end
      
      theend = block3 unless theend
      [buffer, theend]
    end
    
  end
      
end  # module Imperative
  
end # class RuleSet
end # module WLang
