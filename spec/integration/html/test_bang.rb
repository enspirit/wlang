require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, "!{...}" do

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    it 'invokes to_s' do
      s = Struct.new(:to_s).new("World")
      render("!{hello}", {:hello => s}).should eq("World")
    end

    it 'works with Numbers' do
      render("!{hello}", {:hello => 12}).should eq("12")
    end

    it 'does not escape html' do
      render("!{hello}", {:hello => "<script>"}).should eq("<script>")
    end

    it 'is not too sensitive to spacing' do
      render("!{ hello }", {:hello => "World"}).should eq("World")
    end

    it 'supports a binding' do
      hello = "World"
      render("!{hello}", binding).should eq("World")
    end

    it 'supports chain invocations' do
      s = Struct.new(:hello).new("World")
      render("!{s.hello}", binding).should eq("World")
    end

  end
end