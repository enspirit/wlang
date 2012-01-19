require 'spec_helper'
module WLang
  describe Dialect::Dispatching do
    include Dialect::Dispatching

    describe 'tag_dispatching_name' do
      it "works with a single char" do
        tag_dispatching_name("$").should eq(:_dtag_36)
      end
      it "works with a multiple chars" do
        tag_dispatching_name("!$").should eq(:_dtag_33_36)
      end
      it "works with an array" do
        tag_dispatching_name(['!', '$']).should eq(:_dtag_33_36)
      end
    end

    describe 'find_dispatching_method' do
      it 'works on exact matching' do
        Foo.find_dispatching_method("!").should eq(['', :_dtag_33])
        Foo.find_dispatching_method("$").should eq(['', :_dtag_36])
      end
      it 'takes the most specific' do
        Foo.find_dispatching_method("@").should eq(['', :_dtag_64])
        Foo.find_dispatching_method("!@").should eq(['', :_dtag_33_64])
      end
      it 'recognizes extras' do
        Foo.find_dispatching_method("@@").should eq(['@', :_dtag_64])
        Foo.find_dispatching_method("@!").should eq(['@', :_dtag_33])
      end
      it 'recognizes missings' do
        Foo.find_dispatching_method("#").should eq(['#', nil])
        Foo.find_dispatching_method("@#").should eq(['@#', nil])
      end
    end

    def normalize_tag_fns(fns, arity)
      with_normalized_fns(fns, arity) do |args,rest|
        [args, rest]
      end
    end

    it 'normalize_tag_fns' do
      normalize_tag_fns([], 0).should eq([[],nil])
      normalize_tag_fns([], 1).should eq([[nil],nil])
      normalize_tag_fns([:a], 1).should eq([[:a],nil])
      normalize_tag_fns([:a], 2).should eq([[:a, nil],nil])
      normalize_tag_fns([:a], 0).should eq([[],[:a]])
      normalize_tag_fns([:a, :b], 0).should eq([[],[:a, :b]])
      normalize_tag_fns([:a, :b], 1).should eq([[:a],[:b]])
      normalize_tag_fns([:a, :b], 2).should eq([[:a, :b],nil])
      normalize_tag_fns([:a, :b], 3).should eq([[:a, :b, nil],nil])
    end

  end # describe Dialect
end # module WLang
