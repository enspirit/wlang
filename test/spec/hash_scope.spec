require 'wlang'
require 'wlang/hash_scope'

describe ::WLang::HashScope do
  
  # Builds a new scope instance, with an optional parent and
  # initial hash
  def newscope(pairing = nil, parent = nil)
    ::WLang::HashScope.new(pairing, parent)
  end
  
  it "should act as a basic hash at first glance" do
    scope = newscope
    scope.has_key?(:hello).should be_false
    scope[:hello] = "world"
    scope.has_key?(:hello).should be_true
    scope[:hello].should == "world"
  end
  
  it "should support a parent" do
    parent = newscope(:hello => "world", :mine => false)
    child = newscope({:mine => true}, parent)

    child.has_key?(:mine).should be_true
    child.has_key?(:hello).should be_true
    child[:mine].should be_true
    child[:hello].should == "world"
  end
  
  it "should never touch its parent" do
    parent = newscope(:hello => "world")
    child = newscope(nil, parent)
    child[:hello].should == "world"
    child[:hello] = "none"
    child[:hello].should == "none"
    parent[:hello].should == "world"
  end
  
  it "should support branching easily" do
    parent = newscope(:hello => "world")
    parent.branch do |scope|
      scope[:who] = "blambeau"
      scope[:who].should == "blambeau" 
      scope[:hello].should == "world" 
      scope[:hello] = "none"
    end
    parent.has_key?(:who).should be_false
    parent[:hello].should == "world"
  end
  
  it "should allow push/pop kind of branching" do
    scope = newscope(:hello => "world")
    scope = scope.branch
    scope[:hello].should == "world"
    scope[:hello] = "none"
    scope[:hello].should == "none"
    scope = scope.parent
    scope[:hello].should == "world"
  end
  
  it "should respect scoping hierarchy" do
    scope = newscope(:hello => "world")
    child = newscope({}, scope)
    child2 = newscope({}, child)

    scope.parent.should be_nil
    scope.root.should == scope

    child.parent.should == scope
    child.root.should == scope

    child2.parent.should == child
    child2.root.should == scope
  end

end