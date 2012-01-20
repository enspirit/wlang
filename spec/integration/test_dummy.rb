require 'spec_helper'
require 'wlang/dummy'
module WLang
  describe Dummy do

  def dummy(tpl, scope = {})
    Dummy.render(tpl, scope)
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
        def dollar(buf, fn)
          buf << evaluate(fn)
        end
        def no_wlang(buf, fn)
          buf << render(fn)
        end
        tag '$', :dollar
        tag '%', [WLang::Dummy], :no_wlang
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
    specify{ d.render(tpl, :who => "world").should eq(expected) }
  end

  end # describe Dummy
end # module WLang
