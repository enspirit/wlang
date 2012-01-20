require File.expand_path('../commons', __FILE__)

Benchmark.bm(10) do |x|
  x.report("mustang") do
    WLang::Mustang.compile("*{1..10000}{!{self}}{, }")
  end
end


