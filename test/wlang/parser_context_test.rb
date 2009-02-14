require 'test/unit/testcase'
require 'wlang'
require 'wlang/parser_context'
module WLang

#
# Tests WLang::Parser::Context class
#
class ParserContextTest
  
  # Sets a context instance
  def setup
    customer = Struct.new(:name, :address)
    hash = {"name" => "blambeau", "age" => 28,
            "customer" => customer.new("Dave", "123 Main")}
    @context = WLang::Parser::Context.new(hash)
  end
  
  # Tests Context#evaluate
  def test_evaluate
    assert_equal("blambeau", @context.evaluate("name"))
    assert_equal("28", @context.evaluate("age"))
    assert_equal("123 Main", @context.evaluate("customer.address"))
  end
  
end # class ParserContextTest
    
end # module WLang