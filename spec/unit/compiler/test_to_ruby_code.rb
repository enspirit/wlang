require 'spec_helper'
module WLang
  describe ToRubyCode do

    let(:generator){ WLang::ToRubyCode.new }

    subject{ generator.call(source) }

    describe '[:proc, ...]' do
      let(:source)  { [:proc, [:static, "Hello world"]] }
      let(:expected){ %q{lambda{|d1,b1| b1 << ("Hello world") }} }
      it{ should eq(expected) }
    end

    describe '[:dispatch, :dynamic, ...] with a single fn' do
      let(:source)  { [:dispatch, :dynamic, "$", [:proc, [:static, "Hello world"]]]      }
      let(:expected){ %q{d0.dispatch("$", b0, [lambda{|d1,b1| b1 << ("Hello world") }])} }
      it{ should eq(expected) }
    end

  end
end
