require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "wlang.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]


task :default => [:all]
task :all => [:test, :rerdoc, :spec, :repackage]

desc "Lauches all tests"
Rake::TestTask.new do |test|
  test.libs       << [ "lib", "test" ]
  test.test_files = ['test/test_all.rb']
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

desc "Generates the specification file"
task :spec => [:rdoc] do |t|
  Kernel.exec("ruby -Ilib bin/wlang --output doc/html/files/specification.html doc/specification/specification.wtpl")
end

desc "Converts SVN log to a CHANGELOG file"
task :cl do |t|
  File.open('CHANGELOG', 'w') do |output|
    Kernel.open("|svn log") do |io|
      io.each do |line|
        case line
        when /^\-+$/, /\s*\[wlang\]\s*/
          next
        when /^(r\d+) \| ([a-z_]+)/
          output << "\n==== #{$1} (#{$2})\n"
        when /^$/
          output << ""
        else
          output << "* #{line}"
        end
      end
    end
  end
end

gemspec = Gem::Specification.new do |s|
  s.name = 'wlang'
  s.version = version
  s.summary = "WLang code generator"
  s.description = %{Simple and powerful code generator and template engine.}
  s.files = Dir['lib/**/*'] + Dir['test/**/*'] + Dir['bin/*'] + Dir['doc/template/*'] + Dir['doc/specification/*']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.author = "Bernard Lambeau"
  s.email = "blambeau@chefbe.net"
  s.homepage = "https://redmine.chefbe.net/projects/revision-zero-public/"
end
Rake::GemPackageTask.new(gemspec) do |pkg|
	pkg.need_tar = true
end
