require File.expand_path('../spec_helper', __FILE__)
describe("WLang should support redcloth encoder") do
  
  it("should support basic redcloth encoding") {
    expected = "<h1>This is a title</h1>"
    WLang::encode("h1. This is a title", "redcloth/xhtml").should == expected
  }
  
  it("should not perturbate template variables with global variables") {
    # RedCloth installs a t global method (which becomes a private method
    # of Object) which was perturbating the HostedLanguage::DSL class.
    # This test acts as a non-regression one.
    require 'rubygems'
    require 'RedCloth'
    "${t}".wlang(:t => 'wlang').should == 'wlang'
    begin
      "${t}".wlang()
      true.should == false
    rescue ::WLang::UndefinedVariableError
      true.should == true
    end
  }
  
end