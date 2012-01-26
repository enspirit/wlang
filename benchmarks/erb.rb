require File.expand_path('../viiite_helper', __FILE__)

Viiite.bench do |b|
  b.variation_point :ruby, Viiite.which_ruby

  b.report(:erb){
    tpl = template("table.erb")
    ERB.new(tpl.read).result(binding)
  }
end
