require 'test/unit'
require 'yaml'
module WLang
  class YAMLAssumptionTest < Test::Unit::TestCase
    
    def test_it_supports_quotes_as_expected
      text = "---\nauthor:\n  \"Bernard Lambeau\"\n"
      x = YAML::load(text)
      assert_equal({'author' => "Bernard Lambeau"}, x)
    end
    
  end # class YAMLAssumptionTest
end # module WLang