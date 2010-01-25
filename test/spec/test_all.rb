$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require 'wlang'
require 'spec/autorun'
test_files = Dir[File.join(File.dirname(__FILE__), '**/*.spec')]
test_files.each { |file|
  load(file) 
}

