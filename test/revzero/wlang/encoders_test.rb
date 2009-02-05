require 'test/unit'
require 'wlang'
module WLang

# Tests Dialect class
class EncodersTest < Test::Unit::TestCase
  
  # Installs a simple upcase/lowcase plain-text dialect
  def setup
    @plain = WLang::Encoders.new
    @plain.add_encoder(:upcase)
    @plain.add_encoder("downcase") {|src,options| src.downcase}
    identity = Proc.new {|src, options| src}
    @plain.add_encoder("identity", identity)
  end
  
  # Tests has_encoder? method
  def test_has_encoder
    assert_equal(true, @plain.has_encoder?("upcase"))
    assert_equal(true, @plain.has_encoder?("downcase"))
    assert_equal(true, @plain.has_encoder?("identity"))
    assert_equal(false, @plain.has_encoder?("encoding"))
  end
  
  # Tests get_encoder method
  def test_get_encoder
    assert_equal(true, @plain.get_encoder("upcase").is_a?(Proc))
    assert_equal(true, @plain.get_encoder("downcase").is_a?(Proc))
    assert_equal(true, @plain.get_encoder("identity").is_a?(Proc))
    assert_nil(@plain.get_encoder("encoding"))
  end
  
  # Tests the encode method
  def test_encode
    assert_equal("IN UPPER CASE", @plain.encode("upcase","in Upper Case"))
    assert_equal("in lower case", @plain.encode("downcase","IN Lower CASE"))
  end
  
    
end # class TargetLanguageTest
    
end # module WLang