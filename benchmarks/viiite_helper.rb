$:.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems' if RUBY_VERSION <= "1.9"
require 'bundler/setup'
require 'wlang/mustang'
require 'wlang/html'
require 'erb'
require 'mustache'
require 'viiite'
require 'epath'

People = Struct.new(:name, :score)

module Helpers

  def people
    @people ||= (1..25000).map{|i|
      People.new("People#{i}", rand)
    }
  end

  def scope
    {:people => people}
  end

  def template(name)
    Path.dir/:templates/name
  end

end
include Helpers
