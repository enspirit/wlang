require 'spec_helper'
module WLang
  describe Dialect::Dispatching do
    include Dialect::Dispatching

    describe 'tag_dispatching_name' do
      it "works with a single char" do
        tag_dispatching_name("$").should eq(:_tag_36)
      end
      it "works with a multiple chars" do
        tag_dispatching_name("!$").should eq(:_tag_33_36)
      end
      it "works with an array" do
        tag_dispatching_name(['!', '$']).should eq(:_tag_33_36)
      end
    end

    describe 'find_dispatching_method' do
      it 'works on exact matching' do
        Foo.find_dispatching_method("!").should eq(['', :_tag_33])
        Foo.find_dispatching_method("$").should eq(['', :_tag_36])
      end
      it 'takes the most specific' do
        Foo.find_dispatching_method("@").should eq(['', :_tag_64])
        Foo.find_dispatching_method("!@").should eq(['', :_tag_33_64])
      end
      it 'recognizes extras' do
        Foo.find_dispatching_method("@@").should eq(['@', :_tag_64])
        Foo.find_dispatching_method("@!").should eq(['@', :_tag_33])
      end
      it 'recognizes missings' do
        Foo.find_dispatching_method("#").should eq(['#', nil])
        Foo.find_dispatching_method("@#").should eq(['@#', nil])
      end
    end

  end # describe Dialect
end # module WLang
