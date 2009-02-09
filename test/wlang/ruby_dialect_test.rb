require 'test/unit'
require 'wlang'
require 'wlang/dialects/standard_dialects'
module WLang

# Tests the rubyy dialect
class RubyDialectTest < Test::Unit::TestCase
  
  # Tests single quoting
  def test_single_quoting
    context = {}
    tests = [
      ["Hello world!", "Hello world!"],
      ["Hello &'{world}!", "Hello world!"],
      ["Hello &'{men's world}!", "Hello men\\'s world!"],
      ["puts 'Hello &'{men's world}!'", "puts 'Hello men\\'s world!'"]
    ]
    tests.each do |test|
      expected = test[1]
      result = test[0].wlang(context, "wlang/ruby")
      assert_equal(expected, result)
    end
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