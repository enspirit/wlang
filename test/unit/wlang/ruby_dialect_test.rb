require 'test/unit/testcase'
require 'wlang'
require 'wlang/dialects/standard_dialects'
module WLang

# Tests the ruby dialect
class RubyDialectTest < Test::Unit::TestCase
  
  def get_file_contents(file)
    file = File.join(File.dirname(__FILE__), file)
    File.read(file)
  end
  
  # Tests on template in HERE documents above 
  def test_on_template 
    $context = {"name" => "O'Neil"}
    $template = get_file_contents('ruby_template.wrb')
    $expected = get_file_contents('ruby_expected.rb')
    result =  $template.wlang($context, "wlang/ruby")
    # puts "\n--template--"
    # puts $template
    # puts "\n--expected--"
    # puts $expected
    # puts "\n--result--"
    # puts result
    assert_equal($expected,result)
  end
  
  # Tests single quoting
  def test_single_quoting
    context = {}
    tests = [
      ["Hello world!", "Hello world!"],
      ["Hello &'{world}!", "Hello world!"],
      ["Hello &'{men's world}!", "Hello men\\'s world!"],
      ["puts 'Hello &'{men's world}!'", "puts 'Hello men\\'s world!'"],
      ["Hello O\'Neil", "Hello O\'Neil"],
      ["Hello O\\'Neil", "Hello O\\'Neil"],
      ["Hello O\\\\'Neil", "Hello O\\\\'Neil"],
    ]
    tests.each do |test|
      expected = test[1]
      result = test[0].wlang(context, "wlang/ruby")
      assert_equal(expected, result)
    end
  
    context = {"name" => %q{O\'Neil}}
    template = %q{puts '{name}'}
    expected = %q{puts 'O\'Neil'}
    result = template.wlang(context, "wlang/ruby")
    assert_equal(expected, result)
  end
  
  # Tests double quoting
  def test_double_quoting
    context = {}
    tests = [
      ['Hello world!', 'Hello world!'],
      ['Hello &"{world}!', 'Hello world!'],
      ['Hello &"{men"s world}!', 'Hello men\\"s world!'],
      ['puts "Hello &"{men"s world}!"', 'puts "Hello men\\"s world!"']
    ]
    tests.each do |test|
      expected = test[1]
      result = test[0].wlang(context, "wlang/ruby")
      assert_equal(expected, result)
    end
  end
  
  # Tests single quoted
  def test_single_quoted
    context = {"name" => "blambeau", "mensworld" => "men's world"}
    tests = [
      ["puts '{name}'", "puts 'blambeau'"],
      ["puts '{mensworld}'", "puts 'men\\'s world'"],
    ]
    tests.each do |test|
      expected = test[1]
      result = test[0].wlang(context, "wlang/ruby")
      assert_equal(expected, result)
    end
  end

  # Tests double quoted
  def test_double_quoted
    context = {"name" => "blambeau", "mensworld" => 'men"s world'}
    tests = [
      ['puts "{name}"', 'puts "blambeau"'],
      ['puts "{mensworld}"', 'puts "men\\"s world"'],
    ]
    tests.each do |test|
      expected = test[1]
      result = test[0].wlang(context, "wlang/ruby")
      assert_equal(expected, result)
    end
  end
  
end # class RubyDialectTest
    
end # module WLang