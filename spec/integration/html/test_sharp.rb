require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, '#{...}' do

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    it 'updates the current scope' do
      scope = {:who => "World"}
      render('Hello #{scope}{${who}}', binding).should eq("Hello World")
    end

    it 'does not follows empty arrays' do
      scope = []
      render('Hello #{scope}{${who}}', binding).should eq("Hello ")
    end

  end
end