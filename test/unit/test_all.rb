$LOAD_PATH.unshift(File.expand_path('../../../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'wlang'
require 'test/unit'
test_files = Dir[File.join(File.dirname(__FILE__), '**/*_test.rb')]
test_files.each { |file|
  require(file) 
}

