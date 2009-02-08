require "wlang/basic_ruleset"
require "wlang/encoding_ruleset"
require "wlang/imperative_ruleset"
require "wlang/buffering_ruleset"
require "wlang/context_ruleset"
module WLang
  
  #
  # Defines standard dialects recognized by wlang. Including this file 
  # (wlang/standard_dialects.rb) will automatically build the standard dialects tree.
  # Those dialects are summarized below
  #
  # == plain-text
  # === encoders
  # [plain-text/upcase] convert source text to upcase (see String#upcase)
  # [plain-text/downcase] convert source text to downcase (see String#downcase)
  # [plain-text/capitalize] capitalize source text to (see String#capitalize)
  #
  module StandardDialects
    
    # plain-text dialect
    WLang::dialect("plain-text") do
      ruby_require("wlang/plain_text_dialect") do
        encoders WLang::Encoders::PlainText 
      end
    end
    
    # ruby dialect
    WLang::dialect("ruby", ".rb", ".ruby") do
      ruby_require "wlang/ruby_dialect" do
        encoders WLang::Encoders::Ruby
      end
    end
    
    # ruby dialect
    WLang::dialect("xhtml", ".html", ".xhtml", ".htm") do
      ruby_require "cgi", "wlang/xhtml_dialect" do
        encoders WLang::Encoders::XHtml
      end
      dialect("coderay") do
        ruby_require("coderay", "wlang/coderay_dialect") do
          encoders WLang::Encoders::CodeRay
        end
      end
    end
    
    # rdoc dialect
    WLang::dialect("rdoc") do
      ruby_require "rdoc", "wlang/rdoc_dialect" do
        encoders WLang::Encoders::RDoc
      end
    end
    
    # wlang dialects
    WLang::dialect("wlang") do
      
      # Dummy dialect, no tag at all
      dialect("dummy") do
      end
      
      # wlang/active-string dialect
      dialect("active-string") do
        rules WLang::RuleSet::Basic
      end
      
      # wlang/ruby dialect
      dialect("ruby", ".wrb", ".wruby") do
        ruby_require "wlang/ruby_dialect" do
          encoders WLang::Encoders::Ruby
          rules WLang::RuleSet::Basic
          rules WLang::RuleSet::Encoding
          rules WLang::RuleSet::Imperative
          rules WLang::RuleSet::Context
          rules WLang::RuleSet::Ruby
        end
      end
      
      # wlang/ruby dialect
      dialect("xhtml", ".wtpl", ".whtml") do
        ruby_require "cgi", "wlang/xhtml_dialect" do
          encoders WLang::Encoders::XHtml
          rules WLang::RuleSet::Basic
          rules WLang::RuleSet::Encoding
          rules WLang::RuleSet::Imperative
          rules WLang::RuleSet::Buffering
          rules WLang::RuleSet::Context
          rules WLang::RuleSet::XHtml
        end
      end
      
    end
  
  end # module StandardDialects

end # module WLang
