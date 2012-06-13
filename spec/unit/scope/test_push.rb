require 'spec_helper'
module WLang
  describe Scope, 'push' do

    let(:x_scope){ Scope.coerce(:x) }

    subject{ x_scope.push(pushed) }

    before do
      subject.should be_a(Scope)
    end

    after do
      x_scope.parent.should be_nil
      x_scope.subject.should eq(:x)
      x_scope.root.should eq(x_scope)
    end

    context 'when pushing a simple value' do
      let(:pushed){ :y }

      it 'returns the scope with correct subject' do
        subject.subject.should eq(:y)
      end

      it 'sets the parent correctly on created scope' do
        subject.parent.should eq(x_scope)
      end

      it 'returns the correct root scope' do
        subject.root.should eq(x_scope)
      end
    end

    context 'when pushing another scope' do
      let(:pushed){ Scope.coerce(:y).push(:z) }

      it 'returns the scope with most specific subject' do
        subject.subject.should eq(:z)
      end

      it 'rechains parents correctly' do
        subject.parent.subject.should eq(:y)
        subject.parent.parent.subject.should eq(:x)
        subject.parent.parent.parent.should be_nil
      end

      it 'returns the correct root scope' do
        subject.root.should eq(x_scope)
      end

      it 'does not touch the original scope' do
        pushed.subject.should eq(:z)
        pushed.parent.subject.should eq(:y)
        pushed.parent.parent.should be_nil
        pushed.root.should eq(pushed.parent)
      end
    end

  end
end