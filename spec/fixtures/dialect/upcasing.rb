class Upcasing < WLang::Dialect

  tag "$" do |buf, fn|
    buf << render(fn).upcase
  end

  tag "#" do |buf, fn|
    if x = evaluate(fn)
      buf << x
    end
  end

end
