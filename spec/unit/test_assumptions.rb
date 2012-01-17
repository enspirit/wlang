require 'spec_helper'
describe "ruby assumptions" do
  
  def arity0();        end
  def arity1(fn);      end
  def arity2(fn1,fn2); end
  
  it 'method arity' do
    self.class.instance_method(:arity0).arity.should eq(0)
    self.class.instance_method(:arity1).arity.should eq(1)
    self.class.instance_method(:arity2).arity.should eq(2)
  end
  
  it "lambda arity" do
    lambda{|| }.arity.should eq(0)
    lambda{|fn|}.arity.should eq(1)
    lambda{|fn1,fn2|}.arity.should eq(2)
  end
  
end
