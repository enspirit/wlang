require 'spec_helper'
module WLang
  class Scope
    public :fetch_one_or_fail
  end
  describe Scope, "fetch_one_or_fail" do
    
    def f(s, k)
      Scope.root.fetch_one_or_fail(s,k)
    end

    context "on a poro" do
      let(:subj){ Struct.new(:who).new("World") }

      it 'evaluates correctly when found' do
        f(subj, :who).should eq("World")
      end
      it 'throws :fail when not found' do
        lambda{ f(subj, :no_such_one) }.should throw_symbol(:fail)
      end
      it 'evaluates `self` correctly' do
        f(subj, :self).should eq(subj)
      end
    end
    
    context "on a Binding" do
      it 'evaluates correctly when found' do
        who = "World"
        f(binding, :who).should eq("World")
      end
      it 'throws :fail when not found' do
        lambda{ f(binding, :no_such_one) }.should throw_symbol(:fail)
      end
      it 'evaluates `self` correctly' do
        o = Object.new
        x = o.instance_eval do
          Scope.root.fetch_one_or_fail(binding, :self)
        end
        x.should eq(o)
      end
    end

    context "on a hash" do
      it 'evaluates correctly when found' do
        f({:who => "World"}, :who).should eq("World")
      end
      it 'throws :fail when not found' do
        lambda{ f({}, :no_such_one) }.should throw_symbol(:fail)
      end
      it 'falls back to hash methods' do
        f({:who => "World"}, :keys).should eq([:who])
      end
      it 'gives priority to keys' do
        f({:keys => "World"}, :keys).should eq("World")
      end
      it 'evaluates `self` correctly' do
        f({:who => "World"}, :self).should eq({:who => "World"})
      end
    end

  end # describe Scope
end # module WLang
