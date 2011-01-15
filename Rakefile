require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "wlang.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d+\.\d+\.\d+)\1/, 2]

task :default => [:all]
task :all => [:test, :specification, :repackage]

desc "Lauches all unit tests"
Rake::TestTask.new(:unit) do |test|
  test.libs       = [ "lib" ]
  test.test_files = ['test/unit/test_all.rb', 
                     'test/blackbox/test_all.rb',
                     'test/standard_dialects/test_all.rb',
                     'test/standard_dialects/**/*_test.rb']
  test.verbose    =  true
end

desc "Runs all tests (unit and rspec)"
task :test => [:unit, :spec]

desc "Generates the specification file"
task :specification do |t|
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
  s.extra_rdoc_files = ["README.md", "LICENCE.md", "CHANGELOG.md"]
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

#
# Install a rake task for running examples written using rspec.
#
# More information about rspec: http://relishapp.com/rspec
# This file has been written to conform to RSpec v2.4.0
#
begin
  require "rspec/core/rake_task"
  desc "Run RSpec code examples"
  RSpec::Core::RakeTask.new(:spec) do |t|
    # Glob pattern to match files.
    t.pattern = 'test/spec/*.spec'

    # Use verbose output. If this is set to true, the task will print the
    # executed spec command to stdout.
    t.verbose = true

    # Command line options to pass to rspec.
    # See 'rspec --help' about this
    t.rspec_opts = %w{--color --backtrace}
  end
rescue LoadError => ex
  task :spec do
    abort 'rspec is not available. In order to run spec, you must: gem install rspec'
  end
ensure
  task :test => [:spec]
end

# 
# Install a rake task to generate API documentation using
# yard.
#
# More information about yard: http://yardoc.org/
# This file has been written to conform to yard v0.6.4
#
# About project documentation
begin
  require "yard"
  desc "Generate yard documentation"
  YARD::Rake::YardocTask.new(:yard) do |t|
    # Array of options passed to the commandline utility
    # See 'yardoc --help' about this
    t.options = %w{--output-dir doc/api - README.md CHANGELOG.md LICENCE.md}
    
    # Array of ruby source files (and any extra documentation files 
    # separated by '-')
    t.files = ['lib/**/*.rb']
    
    # A proc to call before running the task
    # t.before = proc{ }
    
    # A proc to call after running the task
    # r.after = proc{ }
    
    # An optional lambda to run against all objects being generated. 
    # Any object that the lambda returns false for will be excluded 
    # from documentation. 
    # t.verifier = lambda{|obj| true}
  end
rescue LoadError
  task :yard do
    abort 'yard is not available. In order to run yard, you must: gem install yard'
  end
end
