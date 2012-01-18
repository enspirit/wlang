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
  
  context "documentation" do
    let(:d){
      dialect do
        tag('$') do |fn| evaluate(fn)                end
        tag('%') do |fn| yield_fn(fn, WLang::Dummy)  end
      end
    }
    let(:tpl){%q{
      Hello ${who}! This is wlang, a templating language which comes with
      special tags such as %{${who}, +{who}, *{authors}{...}, etc.}
    }.gsub(/^\s*/m,"").strip}
    let(:expected){%q{
      Hello world! This is wlang, a templating language which comes with
      special tags such as ${who}, +{who}, *{authors}{...}, etc.
    }.gsub(/^\s*/m,"").strip}
    specify{ d.instantiate(tpl, :who => "world").should eq(expected) }
  end
  
end
