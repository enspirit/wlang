require "citrus"
require "temple"
if RUBY_VERSION < "1.9"
  require 'backports'
  require "backports/basic_object" unless defined?(BasicObject)
end