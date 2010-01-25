require 'test/unit/testcase'
require 'wlang'
require 'wlang/rulesets/basic_ruleset'
require 'wlang/rulesets/context_ruleset'

# Tests the Scoping ruleset
class WLang::ContextRuleSetTest < Test::Unit::TestCase

  # Installs a dialect on wlang
  def setup
    WLang::dialect "context-test" do 
      rules WLang::RuleSet::Basic
      rules WLang::RuleSet::Context
    end
  end
  
  # Tests the define decoder
  def test_block_assignment
    tests = [
      ["#={code}{hello}+{code}", "hello"],
      ["#={code}{hello}{+{code}}", "hello"],
      ["#={code}{%{wlang/dummy}{hello}}{+{code}}", "hello"],
      ["#={code}{%{wlang/dummy}{+{hello}}}{+{code}}", "+{hello}"]
    ]
    tests.each do |test|
      template, expected = test
      result = template.wlang(nil, "context-test")
      assert_equal(expected, result)
    end
  end
    
end # class WLang::ScopingRuleSetTest
