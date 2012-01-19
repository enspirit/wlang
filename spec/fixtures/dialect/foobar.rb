class Foo < WLang::Dialect

  def _(fn)
    fn ? render(fn) : nil
  end

  def execution(buf, fn)
    buf << "(foo#execution #{_ fn})"
  end

  def escaping(buf, fn)
    buf << "(foo#escaping #{_ fn})"
  end

  tag "!", :execution
  tag "$", :escaping
  tag "@"  do |buf,fn| buf << "(foo#link #{_ fn})";   end
  tag "<"  do |buf,fn| buf << "(foo#less #{_ fn})";   end
  tag '!@' do |buf,fn| buf << "(foo#bangat #{_ fn})"; end
end

class Bar < Foo

  def escaping(buf, fn)
    buf << "(bar#escaping #{_ fn})"
  end

  tag "$", :escaping
  tag "<" do |buf,fn| buf << "(bar#less #{_ fn})";    end
  tag ">" do |buf,fn| buf << "(bar#greater #{_ fn})"; end
end
