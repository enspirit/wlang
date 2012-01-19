class Upcasing < WLang::Dialect
  
  tag "$" do |buf, fn|
    buf << instantiate(fn).upcase
  end
  
end

