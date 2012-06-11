require 'spec_helper'
module WLang
  describe Dialect, 'new' do

    let(:base){ Dialect.default_options }
    let(:template){ Template.new "blah" }

    subject{ Dialect.new(*args) }

    context 'with no arguments' do
      let(:args){ [] }
      it 'should have default options' do
        subject.options.should eq(base)
      end
      it 'should not have a template' do
        subject.template.should be_nil
      end
    end

    context 'with only options' do
      let(:args){ [{:foo => :bar}] }
      it 'should have merged options' do
        subject.options.should eq(base.merge(:foo => :bar))
      end
      it 'should not have a template' do
        subject.template.should be_nil
      end
    end

    context 'with only a template' do
      let(:args){ [template] }
      it 'should have default options' do
        subject.options.should eq(base)
      end
      it 'should not have a template' do
        subject.template.should eq(template)
      end
    end

    context 'with options and a template' do
      let(:args){ [{:foo => :bar}, template] }
      it 'should have merged options' do
        subject.options.should eq(base.merge(:foo => :bar))
      end
      it 'should not have a template' do
        subject.template.should eq(template)
      end
    end

    context 'with options and a template in reverse order' do
      let(:args){ [template, {:foo => :bar}] }
      it 'should have merged options' do
        subject.options.should eq(base.merge(:foo => :bar))
      end
      it 'should not have a template' do
        subject.template.should eq(template)
      end
    end

  end # describe Dialect, 'new'
end # module WLang
