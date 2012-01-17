$:.unshift File.expand_path('../../lib', __FILE__)
$:.unshift File.expand_path('../../spec', __FILE__)
require 'benchmark'
require 'spec_helper'
require 'fixtures/mustiche'

tpl      = "*{1..10000}{!{self}}{, }"
compiled = Mustiche.compile(tpl)
template = Mustiche.template(tpl)

puts compiled

Benchmark.bm do |x|
  x.report(:wlang){
    template.call(nil)
  }
  x.report(:native){
    buf = ""
    (1..10000).each{|i| 
      buf << ", " unless buf.empty?
      buf << i.to_s
    }
    buf
  }
end