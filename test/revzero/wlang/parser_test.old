require 'test/unit'
require 'wlang'
module WLang
  
class ParserTest < Test::Unit::TestCase

  # Asserts the result of an instanciation
  def assert_instanciation_equal(expected, template, msg=nil)
    assert_equal(expected, @parser.instanciate(template,""))
  end
  
  # Installs a simple parser with upcase, downcase rules
  def setup
    @parser = WLang::Parser.new
    @parser.add_dialect(:upcaser) do |d|
      d.add_rule('+', WLang::Rule.UPCASE)
      d.add_rule('-', WLang::Rule.DOWNCASE)
    end
  end
  
  def test_parser_accepts_whole_tag
    template, expected = "+{hello}", "HELLO"
    assert_instanciation_equal(expected, template)
    template, expected = " +{hello} ", " HELLO "
    assert_instanciation_equal(expected, template)
  end

  def test_parser_accepts_whole_block
    template, expected = "{hello}", "{hello}"
    assert_instanciation_equal(expected, template)
  end
        
  def test_parser_ignores_backslashed_tags
    template, expected = "\\+{hello\\}", "+{hello}"
    assert_instanciation_equal(expected, template)
  end
  
  def test_parser_ignores_backslashed_blocks
    template, expected = "\\{hello\\} world", "{hello} world"
    assert_instanciation_equal(expected, template)
  end
  
  def test_parser_on_a_complex_case
    template = "Hello \\\\} world! -{ITEMS AS I}{do +{something} \\{with \\} i} here is my name:+{name} and { that's not -{COMMON} text } !\\{"
    expected = "Hello \\} world! items as i{do SOMETHING {with } i} here is my name:NAME and { that's not common text } !\{"
    assert_instanciation_equal(expected, template)
  end
  
end # ParserTest

end # WLang