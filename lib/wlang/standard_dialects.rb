require "wlang/basic_ruleset"
require "wlang/encoding_ruleset"
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
      require("wlang/plain_text_dialect")
      encoders(WLang::Encoders::PlainText) 
    end
    
    # ruby dialect
    WLang::dialect("ruby") do
      require "wlang/ruby_dialect"
      encoders(WLang::Encoders::Ruby)
    end
    
    # wlang dialects
    WLang::dialect("wlang") do
      
      # Dummy dialect, no tag at all
      dialect("dummy") do
      end
      
      # wlang/active-string dialect
      dialect("active-string") do
        rules(WLang::RuleSet::Basic)
      end
      
      # wlang/ruby dialect
      dialect("ruby") do
        require "wlang/ruby_dialect"
        encoders(WLang::Encoders::Ruby)
        rules(WLang::RuleSet::Basic)
        rules(WLang::RuleSet::Encoding)
        rules(WLang::RuleSet::Ruby)
      end
      
    end
  
  end # module StandardDialects

end # module WLang
