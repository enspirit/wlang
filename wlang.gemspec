$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require "wlang/version"
$version = WLang::Version.to_s

Gem::Specification.new do |s|
  s.name = "wlang"
  s.version = $version
  s.summary = "WLang is a powerful code generation and templating engine"
  s.description = "WLang is a general-purpose *code generation*/*templating engine*. It's main aim is to\nhelp you generating web pages, sql queries, ruby code (that is, generating text in\ngeneral) without having to worry too much about html entities encoding, sql back\nquoting, string escaping and the like. WLang proposes a generic engine that you can\neasily extend to fit your needs. It also proposes standard instantiations of this\nengine for common tasks such as rendering HTML web pages."
  s.homepage = "http://github.com/blambeau/wlang"
  s.authors = ["Bernard Lambeau", "Louis Lambeau"]
  s.email  = ["blambeau@gmail.com", "llambeau@gmail.com"]
  s.require_paths = ["lib"]
  here = File.expand_path(File.dirname(__FILE__))
  s.files = File.readlines(File.join(here, 'Manifest.txt')).
                 inject([]){|files, pattern| files + Dir[File.join(here, pattern.strip)]}.
                 collect{|x| x[(1+here.size)..-1]}
  s.test_files = Dir["test/**/*"] + Dir["spec/**/*"]
  s.bindir = "bin"
  s.executables = (Dir["bin/*"]).collect{|f| File.basename(f)}

  s.add_development_dependency("rake", "~> 13.0")
  s.add_development_dependency("rspec", "~> 3.0")

  s.add_dependency("citrus", "~> 3.0")
  s.add_dependency("quickl", "~> 0.4.3")
  s.add_dependency("path", "~> 2.0")
  s.add_dependency("temple", "~> 0.6")

  s.extra_rdoc_files = Dir["README.md"] + Dir["CHANGELOG.md"] + Dir["LICENCE.md"]
end
