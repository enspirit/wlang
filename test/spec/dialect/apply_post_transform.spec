describe "WLang::Dialect#post_transform" do
  
  let(:dialect){ WLang::Dialect.new("test", nil) }
  subject{ dialect.apply_post_transform("hello") }
  
  context "when a string has been installed" do
    before{ dialect.post_transformer = "plain-text/upcase" }
    it{ should == "HELLO" }
  end
  
  context "when a a has been installed" do
    before{ dialect.post_transformer = lambda{|txt| "yes!#{txt}"} }
    it{ should == "yes!hello" }
  end
  
end