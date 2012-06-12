require 'spec_helper'
module WLang
  describe Template, 'path' do

    subject{ template.path }

    context 'when a string and no option' do
      let(:template){ Template.new("Hello ${who}!") }
      it{ should be_nil }
    end

    context 'when a Path and no option' do
      let(:template){ Template.new(Path.here) }
      it{ should eq(__FILE__) }
    end

    context 'when a string and an option' do
      let(:template){ Template.new("Hello ${who}!", :path => __FILE__) }
      it{ should eq(__FILE__) }
    end

    context 'when a path an an option' do
      let(:template){ Template.new(Path.here, :path => __FILE__) }
      it{ should eq(__FILE__) }
    end

  end
end