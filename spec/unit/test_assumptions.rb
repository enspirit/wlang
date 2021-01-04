require 'spec_helper'
describe "ruby assumptions" do

  def arity0();        end
  def arity1(fn);      end
  def arity2(fn1,fn2); end

  it 'String#to_path does not exist' do
    ''.should_not respond_to(:to_path)
  end

  it 'Pathname#to_path does exist' do
    require 'pathname'
    Pathname.new('.').should respond_to(:to_path) if RUBY_VERSION >= "1.9"
  end

  it 'method arity' do
    self.class.instance_method(:arity0).arity.should eq(0)
    self.class.instance_method(:arity1).arity.should eq(1)
    self.class.instance_method(:arity2).arity.should eq(2)
  end

  it "lambda arity" do
    lambda{|| }.arity.should eq(0)
    (lambda{ }.arity <= 0).should be_truthy
    lambda{|fn|}.arity.should eq(1)
    lambda{|fn1,fn2|}.arity.should eq(2)
  end

  it 'allows using a Proc usable in a case statement' do
    proc = lambda{|x| x > 10}
    [ 17, 3 ].map{|x|
      case x
        when proc then x*10
        else
          x
      end
    }.should eq([170, 3])
  end

end
