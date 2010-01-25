require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require 'spec/rake/spectask'
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "wlang.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]


task :default => [:all]
task :all => [:test, :rerdoc, :specification, :repackage]

desc "Lauches all unit tests"
Rake::TestTask.new(:unit) do |test|
  test.libs       = [ "lib", "test/unit" ]
  test.test_files = ['test/unit/test_all.rb', 'test/blackbox/test_all.rb']
  test.verbose    =  true
end

desc "Runs all rspec test"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['test/spec/test_all.rb']
end

desc "Runs all tests (unit and rspec)"
task :test => [:unit, :spec]

desc "Generates rdoc documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include( "README.rdoc", "LICENCE.rdoc", "lib/" )
  rdoc.main     = "README.rdoc"
  rdoc.rdoc_dir = "doc/api"
  rdoc.title    = "WLang Documentation"
end

desc "Generates the specification file"
task :specification => :rerdoc do |t|
  Kernel.exec("ruby -Ilib bin/wlang --methodize --output doc/specification/specification.html doc/specification/specification.wtpl")
end

gemspec = Gem::Specification.new do |s|
  s.name = 'wlang'
  s.version = version
  s.summary = "WLang code generator"
  s.description = %{Simple and powerful code generator and template engine.}
  s.files = Dir['lib/**/*'] + Dir['test/**/*'] + Dir['bin/*'] + Dir['doc/template/*'] + Dir['doc/specification/*']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENCE.rdoc"]
  s.rdoc_options << '--title' << 'WLang - Code generator and Template engine' <<
                    '--main' << 'README.rdoc' <<
                    '--line-numbers'  
  s.bindir = "bin"
  s.executables = ["wlang"]
  s.author = "Bernard Lambeau"
  s.email = "blambeau@gmail.com"
  s.homepage = "http://blambeau.github.com/wlang/"
end
Rake::GemPackageTask.new(gemspec) do |pkg|
	pkg.need_tar = true
end
