require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, "${...}" do

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    it 'escapes html' do
      hello = "<script>"
      render("${hello}", binding).should eq("&lt;script&gt;")
    end

  end
end