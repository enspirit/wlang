require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, "%{...}" do

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    it 'disables wlang inside the block' do
      who = "World"
      render("%{Hello ${who}!}", binding).should eq("Hello ${who}!")
    end

  end
end