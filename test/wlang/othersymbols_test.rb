require 'wlang'
require 'test/unit'
module WLang
  class OtherSymbolsTest < Test::Unit::TestCase
    
    def test_on_parentheses
      template = "+{who}"
      assert_equal 'blambeau', WLang.instantiate(template, {'who' => 'blambeau'}, 'wlang/active-string', :braces).to_s
      template = "+(who)"
      assert_equal 'blambeau', WLang.instantiate(template, {'who' => 'blambeau'}, 'wlang/active-string', :parentheses).to_s
      template = "+[who]"
      assert_equal 'blambeau', WLang.instantiate(template, {'who' => 'blambeau'}, 'wlang/active-string', :brackets).to_s
    end
    
  end
end