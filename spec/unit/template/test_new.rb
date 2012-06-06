require 'spec_helper'
module WLang
  describe Template, '.new' do

    it 'returns a Template instance' do
      Template.new("Hello ${who}!").should be_a(Template)
    end

    it 'allows specifying the dialect to use' do
      t = Template.new("Hello ${who}!", :dialect => Upcasing)
      t.dialect.should eq(Upcasing)
    end

    it 'uses WLang::Html as default dialect' do
      t = Template.new("Hello ${who}!")
      t.dialect.should eq(Html)
    end

  end
end