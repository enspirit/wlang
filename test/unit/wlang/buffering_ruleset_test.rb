require 'test/unit'
require 'wlang'
require File.join(File.dirname(__FILE__), 'test_utils.rb')
require 'wlang/rulesets/buffering_ruleset'

# Tests the Scoping ruleset
class WLang::BufferingRuleSetTest < Test::Unit::TestCase
  include WLang::TestUtils
  
  # Installs a dialect on wlang
  def setup
    WLang::dialect "buffering-test" do 
      rules WLang::RuleSet::Basic
      rules WLang::RuleSet::Buffering
      rule ';' do |parser, offset|
        text, reached = parser.parse(offset)
        [text.upcase, reached]
      end
    end
  end
  
  # Tests input rule
  def test_input
    expected = read_relative_file("ruby_template.wrb", __FILE__)
    template = relative_template("<<{ruby_template.wrb}", "buffering-test", __FILE__)
    result = template.instantiate()
    assert_equal(expected, result)
  end
    
  # Tests that input rule allows creating file name in wlang
  def test_input_accepts_injection
    expected = read_relative_file("ruby_template.wrb", __FILE__)
    template = relative_template("<<{ruby_template.wrb}", "buffering-test", __FILE__)
    result = template.instantiate("ext" => "wrb")
    assert_equal(expected, result)
  end
  
  # Tests output rule
  def test_output
    output = relative_file("buffering_ruleset_test_output.txt", __FILE__)
    File.delete(output) if File.exists?(output)
    template = relative_template(">>{buffering_ruleset_test_output.txt}{an output}", "buffering-test", __FILE__)
    assert_equal("", template.instantiate)
    assert_equal("an output", File.read(output))
    File.delete(output) if File.exists?(output)
  end
  
  # Tests output rule allows creating file name in wlang
  def test_output_accepts_injection
    output = relative_file("buffering_ruleset_test_output.txt", __FILE__)
    File.delete(output) if File.exists?(output)
    template = relative_template(">>{buffering_ruleset_test_output.${ext}}{an output}", "buffering-test", __FILE__)
    assert_equal("", template.instantiate("ext" => "txt"))
    assert_equal("an output", File.read(output))
    File.delete(output) if File.exists?(output)
  end
  
  # Tests output rule parses the second block in same dialect
  def test_output_stays_in_same_dialect
    output = relative_file("buffering_ruleset_test_output.txt", __FILE__)
    File.delete(output) if File.exists?(output)
    template = relative_template(">>{buffering_ruleset_test_output.txt}{;{an output}}", "buffering-test", __FILE__)
    assert_equal("", template.instantiate())
    assert_equal("AN OUTPUT", File.read(output))
    File.delete(output) if File.exists?(output)
  end
  
  def test_output_created_dirs
    output = relative_file("buffering_ruleset_output/buffering_ruleset_test_output.txt", __FILE__)
    File.delete(output) if File.exists?(output)
    template = relative_template(">>{buffering_ruleset_output/buffering_ruleset_test_output.txt}{an output}", "buffering-test", __FILE__)
    assert_equal("", template.instantiate())
    assert_equal("an output", File.read(output))
    File.delete(output) if File.exists?(output)
  end
  
  def test_output_multiple_created_dirs
    output = relative_file("buffering_ruleset_output/subdir/subdir/buffering_ruleset_test_output.txt", __FILE__)
    File.delete(output) if File.exists?(output)
    template = relative_template(">>{buffering_ruleset_output/subdir/subdir/buffering_ruleset_test_output.txt}{an output}", "buffering-test", __FILE__)
    assert_equal("", template.instantiate())
    assert_equal("an output", File.read(output))
    File.delete(output) if File.exists?(output)
  end
  
  # Tests that an included template can include other thinks
  def test_inclusion_in_include_template_works
    expected = "template3"
    file = relative_file("buffering_template1.wtpl", __FILE__)
    result = WLang::file_instantiate(file) 
    assert_equal(expected, result)
  end
  
  # Tests that an included template can include other thinks
  def test_with_works_in_inclusion
    expected = "blambeau world"
    file = relative_file("buffering_template4.wtpl", __FILE__)
    result = WLang::file_instantiate(file, {"who" => "blambeau"}) 
    assert_equal(expected, result)
  end
  
end # class WLang::ScopingRuleSetTest
