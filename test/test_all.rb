require 'wlang'
test_files = Dir['**/*_test.rb']
test_files.each { |file|
  require(file) 
}

