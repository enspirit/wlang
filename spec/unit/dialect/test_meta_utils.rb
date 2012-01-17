require 'spec_helper'
module WLang
  describe Dialect::MetaUtils do
    include Dialect::MetaUtils
    
    describe 'dispatch_name' do
      it "works with a single char" do
        dispatch_name("$").should eq(:_drule_36)
      end
      it "works with a multiple chars" do
        dispatch_name("$$").should eq(:_drule_36_36)
      end
    end
    
    it 'normalize_fns' do
      normalize_fns([], 0).should eq([[],[]])
      normalize_fns([], 1).should eq([[nil],[]])
      normalize_fns([:a], 1).should eq([[:a],[]])
      normalize_fns([:a], 2).should eq([[:a, nil],[]])
      normalize_fns([:a], 0).should eq([[],[:a]])
      normalize_fns([:a, :b], 0).should eq([[],[:a, :b]])
      normalize_fns([:a, :b], 1).should eq([[:a],[:b]])
      normalize_fns([:a, :b], 2).should eq([[:a, :b],[]])
      normalize_fns([:a, :b], 3).should eq([[:a, :b, nil],[]])
    end
    
  end # describe Dialect
end # module WLang
