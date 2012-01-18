require 'spec_helper'
describe Mustiche do

  def m(tpl, scope = {})
    Mustiche.instantiate(tpl, scope)
  end

  it '!{...} calls to_s on strings' do
    m("Hello !{who}!", {:who => "World"}).should eq("Hello World!")
  end

  it '!{...} calls to_s on numerics' do
    m("Hello !{who}!", {:who => 12}).should eq("Hello 12!")
  end

  it '!{...} is not pertubrated by !!{...}' do
    m("Hello !!{who}!", {:who => "World"}).should eq("Hello !World!")
  end

  it '${...} should escape html entities' do
    m("Hello ${who}!", {:who => "&"}).should eq("Hello &amp;!")
  end

  it '*{...} should iterate' do
    tpl = "Hello *{numbers}{!{self}}!"
    m(tpl, {:numbers => [1,2,3]}).should eq("Hello 123!")
  end

  it '*{...} should have a third optional block' do
    tpl = "Hello *{numbers}{!{self}}{, }!"
    m(tpl, {:numbers => [1,2,3]}).should eq("Hello 1, 2, 3!")
  end

end
