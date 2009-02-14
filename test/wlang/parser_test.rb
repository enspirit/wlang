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
  
  # Instanciate the given string as template
  def instantiate_str(str)
    Parser.instantiator(Template.new(str, "example")).instantiate()[0]
  end
  
  # Asserts the result of an instanciation
  def assert_instanciation_equal(expected, template, msg=nil)
    template = Template.new(template, "example")
    parser = Parser.instantiator(template)
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
  
  def test_parser_raises_error
    # Unclosed tag    
    assert_raise(ParseError){instantiate_str("-{unclosedtag")}
  end

  def assert_error_at_line_column(template, line, column)
    begin
      instantiate_str(template)
      assert(false)
    rescue ParseError => ex
      assert_equal ex.line, line, "Line matches"
      assert_equal ex.column, column, "Column matches"
    end
  end
  
  def test_parser_error_find_line_and_column
    assert_error_at_line_column("-{tag", 1, 5)
    assert_error_at_line_column("-{tag with spaces   ", 1, 20)
    assert_error_at_line_column("-{tag as i}{\n", 1, 12)
    assert_error_at_line_column("-{tag as i}{\n\n", 1, 12)
    assert_error_at_line_column("-{tag as i}{\ntext\n", 2, 4)
    assert_error_at_line_column("-{tag as i}{\n\ntext\n", 3, 4)
    assert_error_at_line_column("-{tag as i}{\n\n\ntext\n", 4, 4)
  end
  
end # ParserTest

end # WLang
