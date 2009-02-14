require 'test/unit/testcase'
require 'test/unit/testresult'
require 'wlang'
require 'wlang/dialects/plain_text_dialect'

# Adds some attribute readers that are useful for report generation.
class Test::Unit::TestResult
  attr_reader :errors, :failures
end

# Adds a 'makerun' method without argument, that will be used by _wlang_
class Test::Unit::TestCase
  # Overrided to return a TestResult instance instead of taking it as argument.
  def makerun
    result = Test::Unit::TestResult.new
    self.run(result) do |mode, name|
    end
    return result
  end
end

# An instance of this class will be passed to _wlang_. It simply allows it 
# to lauch tests and collect statistics about them.
class TestReport
  
  # Automatically loads all test files, looking for TestCase subclasses.
  # Collects TestSuite instances on these classes.
  def test_suites
    Dir["**/*_test.rb"].collect do |file|
      next if /\.svn/ =~ file
      begin
        load(file)
      rescue Exception => ex
        puts "Unable to load test file #{file}: #{ex.message}"
      end
    end
    suites = []
    ObjectSpace.each_object(Class) do |klass|
      suites << klass.suite if(klass < Test::Unit::TestCase)
    end
    suites
  end
  
end

# We create an instance as file result: this instance will be passed to _wlang_
# by using --context-name option of the wlang command line.
TestReport.new
