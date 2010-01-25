require 'test/unit/testcase'
require 'wlang'
require 'wlang/dialects/plain_text_dialect'

class WLang::PlainTestDialectTest < Test::Unit::TestCase
  
  # Tests the camel case function
  def test_camel_case
    tests = [
      ["blambeau", "Blambeau"],
      ["the world and the cat", "TheWorldAndTheCat"],
      ["\nthe\t world   and-the_cat", "TheWorldAndTheCat"],
      #["l'éléphant", "LElephant"],
    ]
    tests.each do |t|
      src, expected = t
      assert_equal(expected, WLang::EncoderSet::PlainText.camel_case(src, nil))
    end
  end
  
end