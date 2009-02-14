require 'test/unit/testcase'

class FailureTest < Test::Unit::TestCase
  
  def test_with_error
    raise "Error during test (example for report)"
  end
  
  def test_with_failure
    assert false, "Failure during test (example for report)"
  end
  
end