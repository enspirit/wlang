require 'spec_helper'
module WLang
  describe Template, 'to_ruby_code' do

    let(:template){ Template.new("Hello ${who}!") }

    it 'it returns some ruby code' do
      expected = %q{Proc.new{|d1,b1| b1 << ("Hello "); d1._tag_36(b1, "who"); b1 << ("!") }}
      template.to_ruby_code.should eq(expected)
    end

  end
end