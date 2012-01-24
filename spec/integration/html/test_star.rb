require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, "*{...}" do

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    let(:numbers){ [1, 2, 3] }

    it 'renders the main block for each element' do
      render("*{numbers}{+{self}}", binding).should eq("123")
    end

    it 'renders the between block if present' do
      render("*{numbers}{+{self}}{,}", binding).should eq("1,2,3")
    end

    it 'renders nothing on empty collections' do
      empty = []
      render("*{empty}{+{self}}", binding).should eq("")
    end

    it 'supports any enumerable' do
      elms = (1..5)
      render("*{elms}{+{self}}{,}", binding).should eq("1,2,3,4,5")
    end

  end
end