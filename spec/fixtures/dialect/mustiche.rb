class Mustiche < WLang::Dialect

  tag '!' do |fn|
    evaluate(fn)
  end

  tag '$' do |fn|
    Temple::Utils.escape_html evaluate(fn)
  end

  tag '*' do |fn1,fn2,fn3|
    buf = ""
    evaluate(fn1).each do |val|
      buf << instantiate(fn3) if fn3 and !buf.empty?
      with_scope(val) do
        buf << instantiate(fn2)
      end
    end
    buf
  end

end
