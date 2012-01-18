class Upcasing < WLang::Dialect
  
  tag "$" do |fn|
    fn.call(self, "").upcase
  end
  
end

