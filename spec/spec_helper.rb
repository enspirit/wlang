require 'path'
$root_folder ||= Path.backfind('.[Rakefile]')

# Require wlang
$LOAD_PATH.unshift(($root_folder/:lib).to_s)
require 'wlang'

# RSpec helpers
require 'rspec'
module Helpers
  include WLang
  extend(self)

  def root_folder
    $root_folder
  end

  def spec_folder
    root_folder/:spec
  end

  def fixtures_folder
    spec_folder/:fixtures
  end

  def tpl_path(what)
    what = "#{what}.wlang" if what.is_a?(Symbol)
    fixtures_folder/:templates/what
  end

  def tpl(what)
    tpl_path(what).read
  end

  # Load fixture dialects
  spec_folder.glob("fixtures/dialect/*.rb").each do |f|
    require f.expand_path
  end

  # Install helper methods for templates
  fixtures_folder.glob("templates/*.wlang").each do |f|
    name = f.basename.without_extension
    define_method(:"#{name}_path") do
      fixtures_folder/:templates/f.basename
    end
    define_method(:"#{name}_tpl") do
      send(:"#{name}_path").read
    end
    define_method(:"#{name}_io") do |&b|
      send(:"#{name}_path").open("r") do |io|
        b.call(io)
      end
    end
  end

end
include Helpers

# Configure rspec
RSpec.configure do |c|
  c.include Helpers
  c.filter_run_excluding :hash_ordering => (RUBY_VERSION < "1.9")
end
