require 'test/unit'
require 'wlang'
module WLang

class WLangTest < Test::Unit::TestCase
  
  # Installs some dialects on wlang
  def setup
    WLang::dialect "plain-text" do 
      require 'wlang/plain_text_dialect'
      encoders WLang::Encoders::PlainText
    end
    
    # wlang dialect, empty by default
    WLang::dialect "wlang" do 
      # wlang/dummy, without any rule
      dialect "dummy" do end
      
      # wlang/plain-text with RuleSet::Basic and RuleSet::PlainText  
      dialect "plain-text" do
        require 'wlang/plain_text_dialect'
        rules WLang::RuleSet::Basic
        rules WLang::RuleSet::PlainText
      end
    end
  end

  # Tests that dialects are recognized  
  def test_dialect
    assert_not_nil(WLang::dialect("plain-text"))
    assert_not_nil(WLang::dialect("wlang"))
    assert_not_nil(WLang::dialect("wlang/dummy"))
    assert_not_nil(WLang::dialect("wlang/plain-text"))
    assert_nil(WLang::dialect("wlang/plain-tet"))
  end
  
  # Tests that encoders are recognized  
  def test_dialect
    assert_not_nil(WLang::encoder("plain-text/upcase"))
    assert_not_nil(WLang::encoder("plain-text/downcase"))
    assert_not_nil(WLang::encoder("plain-text/capitalize"))
    assert_nil(WLang::encoder("plain-text/capize"))
  end
  
  # Tests the regular expression for dialect names
  def test_dialect_name_regexp
    assert_not_nil(WLang::DIALECT_NAME_REGEXP =~ "wlang")
    assert_not_nil(WLang::DIALECT_NAME_REGEXP =~ "wlang/plain-text")
    assert_not_nil(WLang::DIALECT_NAME_REGEXP =~ "wlang/xhtml")
    assert_not_nil(WLang::DIALECT_NAME_REGEXP =~ "wlang/sql")
    assert_not_nil(WLang::DIALECT_NAME_REGEXP =~ "wlang/sql/sybase")
    assert_nil(WLang::DIALECT_NAME_REGEXP =~ "WLang")
    assert_nil(WLang::DIALECT_NAME_REGEXP =~ "WLang/sql")
    assert_nil(WLang::DIALECT_NAME_REGEXP =~ "wlang/sql/ sybase")
  end
  
  # Tests some classical uses of dialect names
  def test_dialect_name_classical_use
    assert_equal(1, "wlang".split('/').length)
    assert_equal(["wlang"], "wlang".split('/'))
    assert_equal("wlang", "wlang".split('/')[0])
    assert_equal(3, "wlang/sql/sybase".split('/').length)
    assert_equal(["wlang","sql","sybase"], "wlang/sql/sybase".split('/'))
    assert_equal(["sql","sybase"], "wlang/sql/sybase".split('/')[1..-1])
  end
  
end # class WLangTest
  
end # module WLang