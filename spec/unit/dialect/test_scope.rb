require 'spec_helper'
module WLang
  class Dialect
    describe Scope do
      
      describe 'coerce' do
        it 'recognizes a scope' do
          s = Scope.new
          Scope.coerce(s).should eq(s)
        end
        it 'coerces to a Scope' do
          s = Scope.coerce(1)
          s.should be_a(Scope)
          s.to_a.should eq([1])
        end
      end
      
      describe 'push' do
        it 'pushes and returns the Scope' do
          s = Scope.new
          s.push(1).should eq(s)
          s.to_a.should eq([1])
        end
      end
      
      describe 'pop' do
        it 'pops and returns the Scope' do
          s = Scope.new.push(1)
          s.pop.should eq(s)
          s.to_a.should eq([])
        end
      end
      
      describe 'each_frame' do
        it 'returns scope objects in reverse order' do
          s = Scope.new.push(1).push(2)
          seen = []
          s.each_frame do |o| seen << o; end
          seen.should eq([2, 1])
        end
        it 'does not fail on empty scope' do
          s = Scope.new
          seen = []
          s.each_frame do |o| seen << o; end
          seen.should eq([])
        end
      end
      
    end # describe Scope
  end # class Dialect
end # module WLang