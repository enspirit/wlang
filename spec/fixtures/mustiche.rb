class Mustiche < WLang::Dialect

  rule '!' do |fn|
    evaluate(_ fn)
  end

  rule '$' do |fn|
    Temple::Utils.escape_html dispatch('!', fn)
  end

  rule '*' do |fn1,fn2,fn3|
    buf = ""
    dispatch('!', fn1).each do |val|
      buf << (_ fn3) if fn3 and !buf.empty?
      with_context(val) do
        buf << (_ fn2)
      end
    end
    buf
  end

end
