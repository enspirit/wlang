require 'test/unit'
require 'wlang'
require 'wlang/dialects/standard_dialects'
require "yaml"

# Tests the example given in the specification
class WLang::SpecificationExamplesTest < Test::Unit::TestCase
  
  # Tests all examples in the specification
  def test_all_examples
    context = {"name" => "O'Neil",
               "author" => "blambeau",
               "authors" => ["blambeau", "llambeau", "ancailliau"]}
    spec_file = File.join(File.dirname(__FILE__),"../../../doc/specification/specification.yml")
    spec = YAML.load(File.open(spec_file))
    spec["rulesets"].each do |ruleset|
      next if ruleset["examples"].nil?
      ruleset["examples"].each do |example|
        dialect, expr, expected = example
        dialect = "wlang/ruby" if dialect=="wlang/*"
        #puts "assuming #{dialect} on #{expr}, gives #{expected}"
        assert_equal(expected, WLang::instantiate(expr, context.dup, dialect))
      end
    end
  end
  
  # Tests that what is said is valid.
  def test_what_is_said_in_specification
    WLang::dialect("specification") do
      rules WLang::RuleSet::Basic
      rules WLang::RuleSet::Imperative
    end
    tests = [
      ["*{authors as who}{${who}}{, }", "blambeau, llambeau, ancailliau"],
      ["*{authors as who}{${who}} {, }", "blambeaullambeauancailliau {, }"],
      ["*{authors as who} {${who}}{, }", nil]
    ]
    context = {"authors" => ["blambeau", "llambeau", "ancailliau"]}
      
    tests.each do |test|
      template, expected = test
      if expected.nil?
        assert_raise WLang::ParseError do
          assert_equal(expected, template.wlang(context, "specification"))
        end
      else
        assert_equal(expected, template.wlang(context, "specification"))
      end
    end
  end
  
end