require 'spec_helper'
module WLang
  describe Dialect::Dispatching do
    include Dialect::Dispatching
    
    describe 'tag_dispatching_name' do
      let(:c){ self.class }
      it "works with a single char" do
        c.tag_dispatching_name("$").should eq(:_dtag_36)
      end
      it "works with a multiple chars" do
        c.tag_dispatching_name("!$").should eq(:_dtag_33_36)
      end
      it "works with an array" do
        c.tag_dispatching_name(['!', '$']).should eq(:_dtag_33_36)
      end
    end
    
    describe 'find_dispatching_method' do
      let(:foo){ Foo.new }
      it 'works on exact matching' do
        find_dispatching_method("!", foo).should eq(['', :_dtag_33])
        find_dispatching_method("$", foo).should eq(['', :_dtag_36])
      end
      it 'takes the most specific' do
        find_dispatching_method("@", foo).should eq(['', :_dtag_64])
        find_dispatching_method("!@", foo).should eq(['', :_dtag_33_64])
      end
      it 'recognizes extras' do
        find_dispatching_method("@@", foo).should eq(['@', :_dtag_64])
        find_dispatching_method("@!", foo).should eq(['@', :_dtag_33])
      end
      it 'recognizes missings' do
        find_dispatching_method("#", foo).should eq(['#', nil])
        find_dispatching_method("@#", foo).should eq(['@#', nil])
      end
    end
    
    it 'normalize_tag_fns' do
      normalize_tag_fns([], 0).should eq([[],[]])
      normalize_tag_fns([], 1).should eq([[nil],[]])
      normalize_tag_fns([:a], 1).should eq([[:a],[]])
      normalize_tag_fns([:a], 2).should eq([[:a, nil],[]])
      normalize_tag_fns([:a], 0).should eq([[],[:a]])
      normalize_tag_fns([:a, :b], 0).should eq([[],[:a, :b]])
      normalize_tag_fns([:a, :b], 1).should eq([[:a],[:b]])
      normalize_tag_fns([:a, :b], 2).should eq([[:a, :b],[]])
      normalize_tag_fns([:a, :b], 3).should eq([[:a, :b, nil],[]])
    end
    
  end # describe Dialect
end # module WLang
