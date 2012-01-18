require 'epath'

module Helpers
  
  def root_folder
    @root_folder ||= Path.backfind('.[Rakefile]')
  end
  
  def spec_folder
    root_folder/:spec
  end
  
  def tpl_path(what)
    what = "#{what}.tpl" if what.is_a?(Symbol)
    spec_folder/:fixtures/:templates/what
  end
  
  def tpl(what)
    tpl_path.read
  end
  
end
include Helpers

# Require wlang
$LOAD_PATH.unshift root_folder/:lib
$LOAD_PATH.unshift root_folder/:spec
require 'wlang'

# Load fixture dialects
spec_folder.glob("fixtures/dialect/*.rb").each do |f|
  require f.expand_path
end

# Configure rspec
RSpec.configure do |c|
  c.include Helpers
end
