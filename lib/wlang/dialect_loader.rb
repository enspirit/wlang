#
# Implements the same API as WLang::Dialect::DSL but used for effective loading.
# This class exists because of the lazy loading design pattern implemented by
# wlang on dialects. It does not convey any user-centric information.
#
class WLang::Dialect::Loader
  
  # Initializes dsl with a real dialect instance
  def initialize(dialect)
    @dialect = dialect
  end
  
  # See WLang::Dialect::DSL#ruby_require
  def ruby_require(*src) 
    src.each do |s|
      begin
        require "rubygems" unless "wlang"==s[0,5]
      rescue Exception => ex
        STDERR.puts "= Error, wlang depends on 'rubygems'\n"\
                    "= Please install it (methods differs from system, in debian : 'apt-get install rubygems')\n"
        exit -1
      end
      begin
        require s
      rescue Exception => ex
        STDERR.puts "= Error in dialect '#{@dialect}'\n"\
                    "= This dialect depends on gem or file '#{s}' (try: 'gem install #{s}')\n"
        exit -1
      end
    end
    yield if block_given?
  end
  
  # See WLang::Dialect::DSL#dialect
  def dialect(name, *extensions, &block) end
  
  # See WLang::Dialect::DSL#encoder
  def encoder(name, &block) 
    @dialect.add_encoder(name, &block)
  end
  
  # See WLang::Dialect::DSL#encoders
  def encoders(mod, pairs=nil) 
    @dialect.add_encoders(mod, pairs)
  end
    
  # See WLang::Dialect::DSL#rule
  def rule(symbol, &block) 
    @dialect.add_rule(symbol, &block)
  end
  
  # See WLang::Dialect::DSL#rules
  def rules(mod, pairs=nil) 
    @dialect.add_rules(mod, pairs)
  end
    
  # See WLang::Dialect::DSL#extensions
  def extensions(*args) end
  alias :extension :extensions 
  
end # class WLang::Dialect::Loader
