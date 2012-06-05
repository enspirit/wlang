require 'spec_helper'
require 'wlang/html'
module WLang
  describe Html, "^{...}" do

    debug = Module.new{ def inspect; "lambda{ #{call.inspect} }"; end }

    def render(tpl, scope = {})
      Html.render(tpl, scope, "")
    end

    [
      false,
      nil,
      lambda{ nil   }.extend(debug),
      lambda{ false }.extend(debug)
    ].each do |test|
      context "when #{test.inspect}" do
        it 'renders the then block' do
          render("^{test}{hello}", binding).should eq("hello")
        end
        it 'does not render the else block' do
          render("^{test}{hello}{otherwise}", binding).should eq("hello")
        end
      end
    end

    [
      true,
      "Something",
      [],
      lambda{ true }.extend(debug),
      lambda{ "something" }.extend(debug)
    ].each do |test|
      context "when #{test.inspect}" do
        it 'do not render the then block' do
          render("^{test}{hello}", binding).should eq("")
        end
        it 'renders the else block if present' do
          render("^{test}{hello}{otherwise}", binding).should eq("otherwise")
        end
      end
    end

  end
end