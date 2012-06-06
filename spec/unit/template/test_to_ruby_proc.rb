require 'spec_helper'
module WLang
  describe Template, 'to_ruby_proc' do

    let(:template){ Template.new("Hello ${who}!") }

    it 'returns a Proc instance' do
      template.to_ruby_proc.should be_a(Proc)
    end

  end
end