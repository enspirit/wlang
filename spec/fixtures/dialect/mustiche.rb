class Mustiche < WLang::Dialect

  tag '!' do |fn|
    evaluate(_ fn).to_s
  end

  tag '$' do |fn|
    Temple::Utils.escape_html evaluate(_ fn).to_s
  end

  tag '*' do |fn1,fn2,fn3|
    buf = ""
    evaluate(_ fn1).each do |val|
      buf << (_ fn3) if fn3 and !buf.empty?
      with_context(val) do
        buf << (_ fn2)
      end
    end
    buf
  end

end
