class Upcasing < WLang::Dialect
  
  tag "$" do |buf, fn|
    buf << render(fn).upcase
  end
  
end

