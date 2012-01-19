$:.unshift File.expand_path('../../lib', __FILE__)
require 'wlang/mustang'
require 'benchmark'
require 'erb'
require 'mustache'

max      = 50000
scope = { :range => (1..max).map{|i| {:i => i}} }

Benchmark.bm(10) do |x|
  x.report(:wlang){
    WLang::Mustang.render('#{range}{${i}, }', scope)
  }
  x.report(:mustache){
    Mustache.render('{{#range}}{{i}}, {{/range}}', scope)
  }
  x.report(:erb){
    tpl = ERB.new(%Q{<% (1..max).each do |i| %><%= i %>, <% end %>})
    tpl.result
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