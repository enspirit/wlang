require 'stringio'
require 'wlang/rule'
require 'wlang/rule_set'
require 'wlang/basic_ruleset'
require 'wlang/encoders'
require 'wlang/dialect'
require 'wlang/parser'

#
# Main module of the WLang /code generator/template engine.
#
module WLang
  
  # Current version of WLang
  VERSION = "0.1.0".freeze
  
  # Regular expression for dialect names
  DIALECT_NAME_REGEXP = /^([-a-z]+)([\/][-a-z]+)*$/
  
  # Regular expression for encoder names
  ENCODER_NAME_REGEXP = /^([-a-z]+)([\/][-a-z]+)*$/
  
  # Main dialect
  @dialect = Dialect.new("")
  
  # Installs a dialect
  def self.dialect(name, &block)
    @dialect.dialect(name, &block)
  end
  
  # Returns an encoder
  def self.encoder(name)
    @dialect.encoder(name)
  end

end

WLang::dialect("ruby") do
  encoders(WLang::Encoders::Ruby)end

WLang::dialect("wlang") do
  
  # Dummy dialect, no tag at all
  dialect("dummy") do |d|
  end
  
  # wlang/active-string dialect
  dialect("active-string") do |d|
    rules(WLang::RuleSet::Basic)
  end
  
  # wlang/ruby dialect
  dialect("ruby") do |d|
    rules(WLang::RuleSet::Basic)
    rules(WLang::RuleSet::Ruby)
  end
  
end