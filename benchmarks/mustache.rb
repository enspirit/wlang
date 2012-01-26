require File.expand_path('../viiite_helper', __FILE__)

Viiite.bench do |b|
  b.variation_point :ruby, Viiite.which_ruby

  b.report(:mutache){
    tpl = template("table.mustache")
     Mustache.render(tpl.read, scope)
  }
end
