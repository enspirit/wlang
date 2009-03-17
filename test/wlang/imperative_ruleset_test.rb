require 'test/unit'
require "wlang"
require 'wlang/rulesets/imperative_ruleset'
module WLang
  
# Tests the Imperative rule set
class ImperativeRuleSetTest < Test::Unit::TestCase
  
  # Installs some dialects on wlang
  def setup
    # wlang dialect, empty by default
    WLang::dialect "imperative-test" do 
      rules WLang::RuleSet::Basic
      rules WLang::RuleSet::Imperative
    end
  end
  
  # Tests the each regexp
  def test_decode_each
    expr = WLang::RuleSet::Utils.expr(:expr,
                                      ["using", :var, false],
                                      ["as", :multi_as, false])
    hash = expr.decode("items")
    assert_equal({:expr => "items", :using => nil, :as => nil}, hash)
    hash = expr.decode("the_items")
    assert_equal({:expr => "the_items", :using => nil, :as => nil}, hash)
    hash = expr.decode("items using each_with_index")
    assert_equal({:expr => "items", :using => "each_with_index", :as => nil}, hash)
    hash = expr.decode("items as x")
    assert_equal({:expr => "items", :using => nil, :as => ["x"]}, hash)
    hash = expr.decode("items using each_with_index as x, i")
    assert_equal({:expr => "items", :using => "each_with_index", :as => ["x", "i"]}, hash)
    hash = expr.decode("names using each_with_index as name, i")
    assert_equal({:expr => "names", :using => "each_with_index", :as => ["name", "i"]}, hash)
    text = "p.items.children   using   each_with_index     as  child,   i"
    assert_not_nil(expr.decode(text))
  end
  
  # Tests merging args
  def test_merge_each_args
    hash = WLang::RuleSet::Imperative.merge_each_args(["item", "index"], [1, 2])
    assert_equal({"item" => 1, "index" => 2}, hash)
    hash = WLang::RuleSet::Imperative.merge_each_args(["item", "index"], [1])
    assert_equal({"item" => 1}, hash)
    hash = WLang::RuleSet::Imperative.merge_each_args(["item"], [1, 2])
    assert_equal({"item" => 1}, hash)
  end
  
  # Tests conditional
  def test_conditional
    context = {"name" => "blambeau", "no" => false, "yes" => true}
    tests = [
      ["?{true}{then} after", "then after"],
      ["?{true}{then}{else} after", "then after"],
      ["?{false}{text} after", " after"],
      ["?{false}{text}{else} after", "else after"],
      ["before ?{true}{then} after", "before then after"],
      ["before ?{true}{then}{else} after", "before then after"],
      ["before ?{false}{text} after", "before  after"],
      ["before ?{false}{text}{else} after", "before else after"],
      ["?{name}{${name}}", "blambeau"],
      ["?{nil}{${name}}{else}", "else"],
      ["?{no}{${name}}", ""],
      ["?{yes}{${name}}", "blambeau"],
    ]
    tests.each do |test|
      result = test[0].wlang_instantiate(context, "imperative-test")
      assert_equal(test[1], result)
    end
  end
  
  # Tests the enumration
  def test_enumeration
    context = {"names" => ["blambeau", "llambeau", "chl"], 
               "empty" => [], 
               "one" => ["blambeau"],
               "two" => ["blambeau", "llambeau"]}
    tests = [
      ['*{["blambeau","llambeau","chl"] as x}{${x}}{, }', "blambeau, llambeau, chl"],
      ["*{names as name}{${name}}", "blambeaullambeauchl"],
      ["*{names as name}{${name}}{, }", "blambeau, llambeau, chl"],
      ["*{names using each_with_index as name, i}{${i}:${name}}{, }", "0:blambeau, 1:llambeau, 2:chl"],
      ["*{empty as e}{+{e}}", ""],
      ["*{empty as e}{+{e}}{}", ""],
      ["*{empty as e}{+{e}}{ }", ""],
      ["*{one as e}{+{e}}", "blambeau"],
      ["*{one as e}{+{e}}{}", "blambeau"],
      ["*{one as e}{+{e}}{ }", "blambeau"],
      ["*{two as t}{+{t}}", "blambeaullambeau"],
      ["*{two as t}{+{t}}{ }", "blambeau llambeau"]
    ]
    tests.each do |test|
      result = test[0].wlang_instantiate(context, "imperative-test")
      assert_equal(test[1], result)
    end
  end
  
end # class ImperativeRuleSetTest

end # module WLang