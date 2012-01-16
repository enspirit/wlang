class Upcasing < WLang::Dialect
  
  rule "!" do |fn|
    fn.call(self, "").upcase
  end
  
end

