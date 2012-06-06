require 'spec_helper'
module WLang
  describe Template, 'yaml_front_matter?' do

    before do
      class Template; public :yaml_front_matter?; end
    end

    it 'is true by default' do
      Template.new("Hello ${who}!").should be_yaml_front_matter
    end

    it 'is can be explicitely enabled' do
      Template.new("Hello ${who}!", :yaml_front_matter => true).should be_yaml_front_matter
    end

    it 'is can be explicitely disabled' do
      Template.new("Hello ${who}!", :yaml_front_matter => false).should_not be_yaml_front_matter
    end

  end
end