module WLang::RuleSet::Utils
  
  # Regexp string for 'dialect'
  DIALECT = WLang::DIALECT_NAME_REGEXP_STR
  
  # Regular expression for 'dialect'
  RG_DIALECT = Regexp.new('^\s*(' + DIALECT + ')\s*$')
  
  # Regexp string for 'encoder'
  ENCODER = WLang::ENCODER_NAME_REGEXP_STR
  
  # Regular expression for 'encoder'
  RG_ENCODER = Regexp.new('^\s*(' + ENCODER + ')\s*$')
  
  # Regexp string for 'qualified/dialect'
  QDIALECT = WLang::QUALIFIED_DIALECT_NAME_REGEXP_STR
  
  # Regular expression for 'qualified/dialect'
  RG_QDIALECT = Regexp.new('^\s*(' + QDIALECT + ')\s*$')
  
  # Regexp string for 'qualified/encoder'
  QENCODER = WLang::QUALIFIED_ENCODER_NAME_REGEXP_STR
  
  # Regular expression for 'qualified/encoder'
  RG_QENCODER = Regexp.new('^\s*(' + QENCODER + ')\s*$')
  
  # Regexp string for 'user_variable'
  VAR = '[a-z_]+'
  
  # Regular expression for 'user_variable'
  RG_VAR = Regexp.new('^\s*(' + VAR + ')\s*$')
  
  # Regexp string for expression in the hosting language
  EXPR = '.*?'
  
  # Regular expression for expression in the hosting language
  RG_EXPR = Regexp.new('^\s*(' + EXPR + ')\s*$')
  
  # Regexp string for 'qualified/dialect as var'
  QDIALECT_AS = '(' + QDIALECT + ')\s+as\s+(' + VAR + ')'
  
  # Regular expression for 'qualified/dialect as var'
  RG_QDIALECT_AS = Regexp.new('^\s*(' + QDIALECT_AS + ')\s*$')
  
  # Regexp string for 'qualified/encoder as var'
  QENCODER_AS = '(' + QENCODER + ')\s+as\s+(' + VAR + ')'
  
  # Regular expression for 'qualified/encoder as var'
  RG_QENCODER_AS = Regexp.new('^\s*(' + QENCODER_AS + ')\s*$')
  
  # Regexp string for 'wlang/hosted as var'
  EXPR_AS = '(' + EXPR + ')\s+as\s+(' + VAR + ')'
  
  # Regular expression for 'wlang/hosted as var'
  RG_EXPR_AS = Regexp.new('^\s*(' + EXPR_AS + ')\s*$')
  
  # Decodes a simple var expression
  def self.decode_var(src)
    match = RG_VAR.match(src)
    return nil unless match
    {:variable => match[1]} 
  end
  
  # Decodes a 'qualified/dialect as var'. Returns a hash
  # with :dialect and :variable keys, or nil if _str_ does
  # not match.
  def self.decode_qdialect_as(str)
    match = RG_QDIALECT_AS.match(str)
    return nil unless match
    {:dialect => match[2], :variable => match[4]} 
  end
  
  # Decodes a 'qualified/encoder as var'. Returns a hash
  # with :encoder and :variable keys, or nil if _str_ does
  # not match.
  def self.decode_qencoder_as(str)
    match = RG_QENCODER_AS.match(str)
    return nil unless match
    {:encoder => match[2], :variable => match[4]} 
  end
  
  # Decodes a 'wlang/hosted as var'. Returns a hash
  # with :expression and :variable keys, or nil if _str_ does
  # not match.
  def self.decode_expr_as(str)
    match = RG_EXPR_AS.match(str)
    return nil unless match
    {:expr => match[2], :variable => match[3]} 
  end
  
end