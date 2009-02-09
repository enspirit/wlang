require 'test/unit'
require 'wlang'
require 'wlang/rulesets/context_ruleset'
module WLang

# Tests the Scoping ruleset
class ContextRuleSetTest < Test::Unit::TestCase

  # Tests the define decoder
  def test_decode_define
    tests = [
      ["items", {:expression => nil, :name => "items"}],
      [" items ", {:expression => nil, :name => "items"}],
      ["items as i", {:expression => "items", :name => "i"}],
      [" items   as   i ", {:expression => "items", :name => "i"}],
      [" items.a.method.call   as   i ", {:expression => "items.a.method.call", :name => "i"}]
    ]
    tests.each do |test|
      result = WLang::RuleSet::Context.decode_define(test[0])
      assert_equal(test[1], result)
    end
  end
    
end # class ScopingRuleSetTest
end # module WLang