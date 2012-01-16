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
  
  rule "!", :execution
  rule "$", :escaping
  rule "@" do |fn| "(foo#link #{_ fn})"; end
  rule "<" do |fn| "(foo#less #{_ fn})"; end
end

class Bar < Foo
  
  def escaping(fn)
    "(bar#escaping #{_ fn})"
  end
  
  rule "$", :escaping
  rule "<" do |fn| "(bar#less #{_ fn})"; end
end

