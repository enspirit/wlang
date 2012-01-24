require File.expand_path('../commons', __FILE__)

Viiite.bench do |b|

  People = Struct.new(:name, :score)
  people = (1..50000).map{|i| People.new("People#{i}", rand)}
  scope  = {:people => people}

  templates = Path.dir/:templates

  b.variation_point :ruby, Viiite.which_ruby

  b.report(:mustang){
    tpl = templates/"table.mustang"
    WLang::Mustang.render(tpl, scope)
  }
  b.report(:html){
    tpl = templates/"table.mustang"
    WLang::Html.render(tpl, scope)
  }
  b.report(:mutache){
    tpl = templates/"table.mustache"
     Mustache.render(tpl.read, scope)
  }
  b.report(:erb){
    tpl = templates/"table.erb"
    ERB.new(tpl.read).result(binding)
  }
end