require 'wlang'
describe ::WLang do
  
  it("should allow easy use of encoders") {
    WLang::encode('&', 'xhtml/entities-encoding').should == '&amp;'
    WLang::encode("O'Neil", 'ruby/single-quoting').should == "O\\'Neil"
    WLang::encode('O"Neil', 'ruby/double-quoting').should == 'O\\"Neil'
    WLang::encode("O'Neil", 'sql/single-quoting').should == "O\\'Neil"
    WLang::encode("O'Neil", 'sql/sybase/single-quoting').should == "O''Neil"
  }
  
  it "should allow easy upper camel casing" do
    WLang::encode('hello_world', 'plain-text/camel-case').should == "HelloWorld"
    WLang::encode('hello_world', 'plain-text/camel').should == "HelloWorld"
    WLang::encode('hello_world', 'plain-text/upper-camel').should == "HelloWorld"
    WLang::encode('this is another example', 'plain-text/camel-case').should == "ThisIsAnotherExample"
    WLang::encode("this is   yet \n another example", 'plain-text/camel-case').should == "ThisIsYetAnotherExample"

    WLang::encode('hello_world', 'plain-text/lower-camel').should == "helloWorld"
  end
  
  it "should allow easy ruby method casing" do
    WLang::encode('helloWorld', 'ruby/method-case').should == "hello_world"
    WLang::encode('HelloWorld', 'ruby/method-case').should == "hello_world"
    WLang::encode('hello world', 'ruby/method-case').should == "hello_world"
    WLang::encode('Hello123World', 'ruby/method-case').should == "hello123_world"
    WLang::encode('HelloWorld_123', 'ruby/method-case').should == "hello_world_123"
    WLang::encode('123_HelloWorld', 'ruby/method-case').should == "_123_hello_world"
  end
  
  it "should have correct examples in README.rdoc" do
    expected = "Hello world!"
    "Hello ${who}!".wlang(:who => 'world').should == expected

    expected = "Hello cruel &amp; world!"
    "Hello ${who}!".wlang({:who => 'cruel & world'}, 'wlang/xhtml').should == expected
  
    expected = "Hello blambeau, llambeau"
    "Hello *{authors as a}{${a}}{, }".wlang(:authors => ['blambeau', 'llambeau']).should == expected

    expected = "INSERT INTO people VALUES ('O\\'Neil')"
    "INSERT INTO people VALUES ('{who}')".wlang({:who => "O'Neil"}, 'wlang/sql')
    
    expected = "Hello wlang!"
    tpl = "Hello $(${varname})!".wlang(:varname => 'who')          
    tpl.wlang({:who => 'wlang'}, 'wlang/active-string', :parentheses).should == expected

    context = {:varname => 'who', :who => 'wlang'}
    expected = "Hello wlang!"
    "Hello ${${varname}}!".wlang(context).should == expected
  end
  
end
