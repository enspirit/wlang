require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "wlang.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

task :default => [:all]
task :all => [:test, :rerdoc]

desc "Lauches all tests"
Rake::TestTask.new do |test|
  test.libs       << [ "lib", "test" ]
  test.test_files =  [ "test/test_all.rb" ]
  test.verbose    =  true
end

desc "Generates rdoc documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include( "README", "INSTALL", "TODO", "CHANGELOG", "LICENCE",
                           "CONTRIBUTE", "BUGS", "lib/" )
  rdoc.main     = "README"
  rdoc.rdoc_dir = "doc/html"
  rdoc.title    = "WLang Documentation"
  rdoc.template = "doc/template/horo"
  rdoc.options << "-S" << "-N" << "-p" << "-H"
end
