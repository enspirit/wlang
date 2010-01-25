require 'test/unit'
require 'wlang'
require 'wlang/test_utils'
require 'wlang/rulesets/basic_ruleset'
require 'wlang/rulesets/context_ruleset'
require 'wlang/rulesets/buffering_ruleset'

# Tests the Basic ruleset
class WLang::BasicRuleSetTest < Test::Unit::TestCase
  include WLang::TestUtils
  
  # Installs a dialect on wlang
  def setup
    WLang::dialect "basic-test" do 
      rules WLang::RuleSet::Basic
      rules WLang::RuleSet::Context
      rules WLang::RuleSet::Buffering
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
    
  # Tests recursive_application rule
  def test_recursive_application
    tests = [
      ["#={code}{%{wlang/dummy}{+{variable}}}"\
       "%!{basic-test with variable: 'hello'}{+{code}}", "hello"],
      ["<<={data.rb as context}"\
       "#={code}{%{wlang/dummy}{+{author}}}"\
       "%!{basic-test using context}{+{code}}", "blambeau"]
    ]
    tests.each do |test|
      template, expected = test
      template = relative_template(template, "basic-test", __FILE__)
      result = template.instantiate()
      assert_equal(expected, result)
    end
  end
  
end # class WLang::BasicRuleSetTest
