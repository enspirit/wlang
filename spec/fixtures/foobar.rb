class Foo < WLang::Dialect

  def _(fn)
    fn ? fn.call(self, "") : nil
  end

  def execution(fn)
    "(foo#execution #{_ fn})"
  end
  
  def escaping(fn)
    "(foo#escaping #{_ fn})"
  end
  
  tag "!", :execution
  tag "$", :escaping
  tag "@"  do |fn| "(foo#link #{_ fn})";   end
  tag "<"  do |fn| "(foo#less #{_ fn})";   end
  tag '!@' do |fn| "(foo#bangat #{_ fn})"; end
end

class Bar < Foo
  
  def escaping(fn)
    "(bar#escaping #{_ fn})"
  end
  
  tag "$", :escaping
  tag "<" do |fn| "(bar#less #{_ fn})"; end
end

