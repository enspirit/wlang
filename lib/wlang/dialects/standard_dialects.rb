require "wlang/rulesets/basic_ruleset"
require "wlang/rulesets/encoding_ruleset"
require "wlang/rulesets/imperative_ruleset"
require "wlang/rulesets/buffering_ruleset"
require "wlang/rulesets/context_ruleset"
  
WLang::data_loader(".yml", ".yaml") do |file|
  require "yaml"
  YAML.load(File.open(file))
end
  
WLang::data_loader(".rb", ".ruby", ".dsl") do |file|
  Kernel.eval(File.read(file))
end

# plain-text dialect
WLang::dialect("plain-text") do
  ruby_require("wlang/dialects/plain_text_dialect") do
    encoders WLang::EncoderSet::PlainText 
  end
end

# ruby dialect
WLang::dialect("ruby", ".rb", ".ruby") do
  ruby_require "wlang/dialects/ruby_dialect" do
    encoders WLang::EncoderSet::Ruby
  end
end

# yaml dialect
WLang::dialect("yaml", ".yaml", ".yml") do
  ruby_require "wlang/dialects/yaml_dialect" do
    encoders WLang::EncoderSet::YAML
  end
end

# sql dialect
WLang::dialect("sql", ".sql") do
  ruby_require "wlang/dialects/sql_dialect" do
    encoders WLang::EncoderSet::SQL
  end
  dialect("sybase", '.sybsql') do
    ruby_require "wlang/dialects/sql_dialect" do
      encoders WLang::EncoderSet::SQL::Sybase
    end
  end
end

# ruby dialect
WLang::dialect("xhtml", ".html", ".xhtml", ".htm") do
  ruby_require "cgi", "wlang/dialects/xhtml_dialect" do
    encoders WLang::EncoderSet::XHtml
  end
  dialect("coderay") do
    ruby_require("coderay", "wlang/dialects/coderay_dialect") do
      encoders WLang::EncoderSet::CodeRayEncoderSet
    end
  end
end

# rdoc dialect
WLang::dialect("rdoc") do
  ruby_require "rdoc", "wlang/dialects/rdoc_dialect" do
    encoders WLang::EncoderSet::RDocEncoders
  end
end

# rdoc dialect
WLang::dialect("redcloth") do
  ruby_require "RedCloth", "wlang/dialects/redcloth_dialect" do
    encoders WLang::EncoderSet::RedClothEncoders
  end
end

# wlang dialects
WLang::dialect("wlang") do
  
  # Dummy dialect, no tag at all
  dialect("dummy") do
  end
  
  # wlang/ruby dialect
  dialect("hosted") do
    ruby_require "wlang/dialects/hosted_dialect" do
      encoders WLang::EncoderSet::Hosted
      rules    WLang::RuleSet::Basic
      rules    WLang::RuleSet::Encoding
      rules    WLang::RuleSet::Imperative
      rules    WLang::RuleSet::Context
      rules    WLang::RuleSet::Hosted
    end
  end
  
  # wlang/active-string dialect
  dialect("active-string") do
    rules WLang::RuleSet::Basic
    rules WLang::RuleSet::Imperative
  end
  
  # wlang/active-text dialect
  dialect("active-text") do
    rules WLang::RuleSet::Basic
    rules WLang::RuleSet::Imperative
    rules WLang::RuleSet::Buffering
    rules WLang::RuleSet::Context
  end
  
  # wlang/uri dialect
  dialect("uri") do
    rules WLang::RuleSet::Basic
  end
  
  # wlang/ruby dialect
  dialect("ruby", ".wrb", ".wruby") do
    ruby_require "wlang/dialects/ruby_dialect" do
      encoders WLang::EncoderSet::Ruby
      rules WLang::RuleSet::Basic
      rules WLang::RuleSet::Encoding
      rules WLang::RuleSet::Imperative
      rules WLang::RuleSet::Buffering
      rules WLang::RuleSet::Context
      rules WLang::RuleSet::Ruby
    end
  end
  
  # wlang/ruby dialect
  dialect("yaml", ".wyaml", ".wyml") do
    ruby_require "wlang/dialects/yaml_dialect" do
      encoders WLang::EncoderSet::YAML
      rules WLang::RuleSet::Basic
      rules WLang::RuleSet::Encoding
      rules WLang::RuleSet::Imperative
      rules WLang::RuleSet::Buffering
      rules WLang::RuleSet::Context
      rules WLang::RuleSet::YAML
    end
  end
  
  # wlang/ruby dialect
  dialect("xhtml", ".wtpl", ".whtml") do
    ruby_require "cgi", "wlang/dialects/xhtml_dialect" do
      encoders WLang::EncoderSet::XHtml
      rules WLang::RuleSet::Basic
      rules WLang::RuleSet::Encoding
      rules WLang::RuleSet::Imperative
      rules WLang::RuleSet::Buffering
      rules WLang::RuleSet::Context
      rules WLang::RuleSet::XHtml
    end
  end
  
  # wlang/ruby dialect
  dialect("sql", ".wsql") do
    ruby_require "wlang/dialects/sql_dialect" do
      encoders WLang::EncoderSet::SQL
      rules WLang::RuleSet::Basic
      rules WLang::RuleSet::Encoding
      rules WLang::RuleSet::Imperative
      rules WLang::RuleSet::SQL
    end

    dialect("sybase") do 
      ruby_require "wlang/dialects/sql_dialect" do
        encoders WLang::EncoderSet::SQL
        encoders WLang::EncoderSet::SQL::Sybase
        rules WLang::RuleSet::Basic
        rules WLang::RuleSet::Encoding
        rules WLang::RuleSet::Imperative
        rules WLang::RuleSet::SQL
      end
    end
  end
  
end
