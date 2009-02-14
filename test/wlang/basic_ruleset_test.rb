require 'test/unit/testcase'
require 'wlang'
require 'wlang/rulesets/context_ruleset'

# Tests the Basic ruleset
class WLang::BasicRuleSetTest < Test::Unit::TestCase
  
  # Installs a dialect on wlang
  def setup
    WLang::dialect "basic-test" do 
      rules WLang::RuleSet::Basic
    end
  end

  # tests !{wlang/hosted} operator
  def test_execution
    tests = [
      ["!{name}", "blambeau", {"name" => "blambeau"}],
      ["!{!{var}}", "blambeau", {"var" => "name", "name" => "blambeau"}],
      ["!{'hello'.upcase}", "HELLO", {}]
    ]
    tests.each do |t|
      template, expected, context = t
      result = template.wlang(context, "basic-test")
      assert_equal(expected, result) 
    end
  end
    
end # class WLang::BasicRuleSetTest
