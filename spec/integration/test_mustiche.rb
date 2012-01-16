require 'spec_helper'
require 'fixtures/mustiche'
describe Mustiche do

  let(:mustiche){ Mustiche.new }

  def m(tpl, context = {})
    mustiche.instantiate(tpl, context)
  end

  it '!{...} to_s on strings' do
    m("Hello !{who}!", {:who => "World"}).should eq("Hello World!")
  end

  it '!{...} to_s on numerics' do
    m("Hello !{who}!", {:who => 12}).should eq("Hello 12!")
  end

  it '${...} should escape html entities' do
    m("Hello ${who}!", {:who => "&"}).should eq("Hello &amp;!")
  end

  it '*{...} should iterate' do
    tpl = "Hello *{numbers}{!{self}}!"
    ctx = {:numbers => [1,2,3]}
    m(tpl, ctx).should eq("Hello 123!")
  end

  it '*{...} should have a third optional block' do
    tpl = "Hello *{numbers}{!{self}}{, }!"
    ctx = {:numbers => [1,2,3]}
    m(tpl, ctx).should eq("Hello 1, 2, 3!")
  end

end
