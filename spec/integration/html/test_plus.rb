require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, "+{...}" do

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    it 'invokes to_html if it exists' do
      hello = Struct.new(:to_html).new("<h1>World</h1>")
      render("+{hello}", binding).should eq("<h1>World</h1>")
    end

    it 'invokes to_s if to_html does not exists' do
      hello = Struct.new(:to_s).new("World")
      render("+{hello}", binding).should eq("World")
    end

    it 'renders the partial if a Template' do
      who   = "World"
      hello = Html.compile("Hello +{who}")
      pending{
        render("+{hello}!", binding).should eq("Hello World!")
      }
    end

  end
end