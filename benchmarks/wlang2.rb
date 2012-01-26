require File.expand_path('../viiite_helper', __FILE__)

Viiite.bench do |b|
  b.variation_point :ruby, Viiite.which_ruby

  b.report(:wlang2){
    tpl = template("table.wlang2")
    WLang::Html.render(tpl, scope)
  }
end
