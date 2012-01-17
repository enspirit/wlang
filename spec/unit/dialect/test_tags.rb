require 'spec_helper'
module WLang
  describe Dialect::Tags do
    include Dialect::Tags
    
    describe 'tag_dispatching_name' do
      it "works with a single char" do
        self.class.tag_dispatching_name("$").should eq(:_dtag_36)
      end
      it "works with a multiple chars" do
        self.class.tag_dispatching_name("$$").should eq(:_dtag_36_36)
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
