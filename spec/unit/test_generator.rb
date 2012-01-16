require 'spec_helper'
module WLang
  describe Generator do
    
    let(:generator){ WLang::Generator.new }
    
    subject{ generator.call(source) }
    
    describe '[:proc, ...]' do
      let(:source)  { [:proc, [:static, "Hello world"]] }
      let(:expected){ %q{lambda{|d1,b1| b1 << ("Hello world") }} }
      it{ should eq(expected) }
    end
    
    describe '[:dispatch, :static, ...] with a single fn' do
      let(:source)  { [:dispatch, :static, "execution", [:proc, [:static, "Hello world"]]]      }
      let(:expected){ %q{_buf << (d0.execution(lambda{|d1,b1| b1 << ("Hello world") }))} }
      it{ should eq(expected) }
    end

    describe '[:dispatch, :dynamic, ...] with a single fn' do
      let(:source)  { [:dispatch, :dynamic, "$", [:proc, [:static, "Hello world"]]]      }
      let(:expected){ %q{_buf << (d0.dispatch("$", lambda{|d1,b1| b1 << ("Hello world") }))} }
      it{ should eq(expected) }
    end

  end
end