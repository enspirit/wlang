spec = Gem::Specification.new do |s|
  s.name = 'wlang'
  s.version = '0.0.1'
  s.summary = "WLang code generator"
  s.description = %{Simple and powerful code generator and template engine.}
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] + Dir['bin/*']
  s.require_path = 'lib'
  s.autorequire = 'builder'
  s.has_rdoc = true
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.author = "Bernard Lambeau"
  s.email = "blambeau@chefbe.net"
  s.homepage = "https://redmine.chefbe.net/projects/revision-zero-public/"
end

