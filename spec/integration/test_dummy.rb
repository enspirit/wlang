require 'spec_helper'
require 'wlang/dummy'
describe WLang::Dummy do
  
  def dummy(tpl, scope = {})
    WLang::Dummy.instantiate(tpl, scope)
  end
  
  it 'returns the string when no tag at all' do
    dummy("Hello world!").should eq("Hello world!")
  end
  
  it 'does not evaluate tags' do
    dummy("Hello ${who}!").should eq("Hello ${who}!")
  end
  
  it 'does not eat other blocks either' do
    dummy("Hello ${who}{ and more}!").should eq("Hello ${who}{ and more}!")
  end
  
  it 'keep single braces in peace' do
    dummy("Hello {who}!").should eq("Hello {who}!")
  end
  
end
