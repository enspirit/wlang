require File.expand_path('../spec_helper', __FILE__)
describe WLang do

  it "should have a version number" do
    WLang.const_defined?(:VERSION).should be_true
  end

  it 'allows building on-the-fly dialects' do
    d = WLang::dialect do
      tag('$') do |buf, fn| 
        buf << evaluate(fn)
      end
    end
    d.render("Hello ${who}!", :who => "world").should eq("Hello world!")
  end

  it 'allows overriding super-dialect tags' do
    d = WLang::dialect(Upcasing) do
      tag('$') do |buf, fn1| 
        buf << render(fn1).capitalize
      end
    end
    d.render('Hello ${world}!').should eq("Hello World!")
  end

  it 'allows overriding super-dialect evaluation rules' do
    d = WLang::dialect do
      evaluator :nofail
      tag('$') do |buf, fn| 
        if x = evaluate(fn)
          buf << x
        end
      end
    end
    d.render('Hello ${who}!').should eq("Hello !")
  end

end
