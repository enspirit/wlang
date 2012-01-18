$:.unshift File.expand_path('../../lib', __FILE__)
require 'wlang/mustang'
require 'benchmark'
require 'mustache'

max      = 50000
scope    = { :range => (1..max).map{|i| {:i => i}} }

Benchmark.bm(10) do |x|
  x.report(:wlang){
    WLang::Mustang.instantiate('#{range}{${i}, }', scope)
  }
  x.report(:mustache){
    Mustache.render('{{#range}}{{i}}, {{/range}}', scope)
  }
  x.report(:native){
    buf = ""
    (1..max).each{|i| 
      buf << i.to_s
      buf << ", "
    }
    buf
  }
end