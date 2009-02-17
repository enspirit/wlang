require 'test/unit/testcase'
require 'wlang'
require 'wlang/dialects/standard_dialects'

module WLang

class WLangTest < Test::Unit::TestCase
  
  # Tests that dialects are recognized  
  def test_dialect
    assert_not_nil(WLang::dialect("plain-text"))
    assert_not_nil(WLang::dialect("wlang"))
    assert_not_nil(WLang::dialect("wlang/dummy"))
    assert_not_nil(WLang::dialect("wlang/active-string"))
    assert_not_nil(WLang::dialect("wlang/ruby"))
    assert_not_nil(WLang::dialect("wlang/xhtml"))
    assert_nil(WLang::dialect("wlang/plain-tet"))
    assert_equal(true, WLang::dialect("wlang/dummy").send(:is_built?))
    assert_equal(true, WLang::dialect("wlang/xhtml").send(:is_built?))
  end
  
  # Tests that encoders are recognized  
  def test_encoder
    assert_not_nil(WLang::encoder("plain-text/upcase"))
    assert_not_nil(WLang::encoder("plain-text/downcase"))
    assert_not_nil(WLang::encoder("plain-text/capitalize"))
    assert_nil(WLang::encoder("plain-text/capize"))
  end
  
  # Tests the regular expression for dialect names
  def test_dialect_name_regexp
    assert_not_nil(WLang::QUALIFIED_DIALECT_NAME_REGEXP =~ "wlang")
    assert_not_nil(WLang::QUALIFIED_DIALECT_NAME_REGEXP =~ "wlang/plain-text")
    assert_not_nil(WLang::QUALIFIED_DIALECT_NAME_REGEXP =~ "wlang/xhtml")
    assert_not_nil(WLang::QUALIFIED_DIALECT_NAME_REGEXP =~ "wlang/sql")
    assert_not_nil(WLang::QUALIFIED_DIALECT_NAME_REGEXP =~ "wlang/sql/sybase")
    assert_nil(WLang::QUALIFIED_DIALECT_NAME_REGEXP =~ "WLang")
    assert_nil(WLang::QUALIFIED_DIALECT_NAME_REGEXP =~ "WLang/sql")
    assert_nil(WLang::QUALIFIED_DIALECT_NAME_REGEXP =~ "wlang/sql/ sybase")
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
  
  # Tests contribution on the String class
  def test_wlang_on_string
    expected = "HELLO blambeau !!"
    result = "^{plain-text/upcase}{hello} ${name} !!".wlang("name" => "blambeau")
    assert_equal(expected, result);
  end

  # Tests that parsing something with %{wlang/dummy}{...} does not interpret 
  # anything.  
  def test_wlang_dummy_does_not_interpret_anything
    template = "${name}"
    assert_equal("${name}", WLang::instantiate(template, nil, "wlang/dummy"))
    
    template = "%{wlang/dummy}{${name}}"
    assert_equal("${name}", WLang::instantiate(template, nil, "wlang/xhtml"))

#    assert_raise do 
#      template = "!{raise('raised')}"
#      WLang::instantiate(template, nil, "wlang/xhtml")
#    end
    assert_nothing_raised do 
      template = "%{wlang/dummy}{!{raise 'Not raised'}}"
      WLang::instantiate(template, nil, "wlang/xhtml")
    end
  end
  
end # class WLangTest
  
end # module WLang