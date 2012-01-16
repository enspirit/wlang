require 'spec_helper'
module WLang
  describe Dialect::MetaUtils do
    include Dialect::MetaUtils
    
    def arity0(); end
    def arity1(fn); end
    def arity2(fn1, fn2); end
    
    describe 'dispatch_name' do
      it "works with a single char" do
        dispatch_name("$").should eq(:_drule_36)
      end
      it "works with a multiple chars" do
        dispatch_name("$$").should eq(:_drule_36_36)
      end
    end
    
    describe 'method_code' do
      it 'works on a proc' do
        l = lambda{|fn| }
        method_code(l).should eq(l)
      end
      it 'works on a symbol' do
        method_code(:arity1, self.class).should eq(self.class.instance_method(:arity1))
      end
    end
    
    describe 'fn_arity' do
      it 'works on procs' do
        fn_arity(lambda{||}).should eq(0)
        fn_arity(lambda{|fn|}).should eq(1)
        fn_arity(lambda{|fn1,fn2|}).should eq(2)
      end
      it 'works on symbols' do
        fn_arity(:arity0, self.class).should eq(0)
        fn_arity(:arity1, self.class).should eq(1)
        fn_arity(:arity2, self.class).should eq(2)
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
