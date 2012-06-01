require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, '/{...}' do

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    it 'does not render anything' do
      scope = {:who => "World"}
      render('Hello /{ a comment } World!', binding).should eq("Hello  World!")
    end

  end
end