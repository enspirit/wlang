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

  ### overriding

  it 'allows overriding super-dialect tags' do
    d = WLang::dialect(Upcasing) do
      tag('$') do |buf, fn1| 
        buf << render(fn1).capitalize
      end
    end
    d.render('Hello ${world}!').should eq("Hello World!")
  end

  it 'allows overriding super-dialect evaluation rules' do
    d = WLang::dialect(Upcasing) do
      default_options :evaluator => [:nofail]
    end
    d.render('Hello #{who}!').should eq("Hello !")
  end

  it 'does not override the super-dialect evaluation rules' do
    d = WLang::dialect(Upcasing) do
      default_options :evaluator => [:nofail]
    end
    lambda{ Upcasing.render('Hello #{who}!') }.should raise_error(NameError)
  end

  it 'allows overriding super-dialect evaluation rules at compile time' do
    Upcasing.compile('Hello #{who}!', :evaluator => [:nofail]).render.should eq("Hello !")
  end

  ### high-order and multi-dialects

  it 'allows high-order constructions' do
    d = WLang::dialect do
      tag '!' do |buf,fn| buf << evaluate(fn).to_s; end
    end
    scope = {:who => :world, :world => "World"}
    d.render('Hello !{!{who}}!', scope).should eq("Hello World!")
  end
  
  it 'allows switching the current dialect' do
    d = WLang::dialect do
      tag '!', [Upcasing] do |buf,fn|
        buf << evaluate(Upcasing.render(fn)).to_s;
      end
    end
    scope = {:WHO => "World"}
    d.render('Hello !{${who}}!', scope).should eq("Hello World!")
  end
  
end
