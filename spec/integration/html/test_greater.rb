require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, ">{...}" do

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    it 'renders a Template object by default' do
      who     = "World"
      partial = Html.compile("${who}")
      render("Hello >{partial}", binding).should eq("Hello World")
    end

    it 'compiles a String to a Template' do
      who     = "World"
      partial = "${who}"
      render("Hello >{partial}", binding).should eq("Hello World")
    end

  end
end