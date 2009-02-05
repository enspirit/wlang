require 'test/unit'
require 'wlang'
module WLang
  
class ParserTest < Test::Unit::TestCase

  # Installs some dialects on wlang
  def setup
    # wlang dialect, empty by default
    WLang::dialect "example" do 
      rule '+' do |parser,offset|
        parsed, reached = parser.parse(offset)
        [parsed.upcase, reached]
      end
      rule '-' do |parser,offset|
        parsed, reached = parser.parse(offset)
        [parsed.downcase, reached]
      end
    end
  end
  
  # Asserts the result of an instanciation
  def assert_instanciation_equal(expected, template, msg=nil)
    dialect = WLang::dialect("example")
    parser = Parser.instantiator(template, dialect)
    assert_equal(expected, parser.instantiate()[0])
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