require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, "+{...}" do

    ToHtml = Struct.new(:to_html)
    ToS    = Struct.new(:to_s)

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    context "on an aribitraty object" do
      it 'invokes to_html if it exists' do
        hello = ToHtml.new("<h1>World</h1>")
        render("+{hello}", binding).should eq("<h1>World</h1>")
      end
      it 'invokes to_s if to_html does not exists' do
        hello = ToS.new("World")
        render("+{hello}", binding).should eq("World")
      end
      it 'invokes to_s on the result of to_html' do
        hello = ToHtml.new(ToS.new("<h1>World</h1>"))
        render("+{hello}", binding).should eq("<h1>World</h1>")
      end
    end
    
    context "on a Template" do
      it 'renders as a partial' do
        who   = "World"
        hello = Html.compile("Hello +{who}")
        render("+{hello}!", binding).should eq("Hello World!")
      end
    end
    
    context "on a Proc" do
      it 'calls it if of arity 0' do
        hello = Proc.new{ "World" }
        render("+{hello}!", binding).should eq("World!")
      end
      it 'it invokes to_html on the result' do
        hello = Proc.new{ ToHtml.new("World") }
        render("+{hello}!", binding).should eq("World!")
      end
    end

  end
end