require 'spec_helper'
module WLang
  describe Template, 'call' do

    let(:template){ Template.new("Hello ${who}!") }

    it 'renders the template to a string by default' do
      template.render(:who => "world").should eq("Hello world!")
    end

    it 'allows specifying a buffer' do
      template.render({:who => "world"}, "Hey, ").should eq("Hey, Hello world!")
    end

  end
end