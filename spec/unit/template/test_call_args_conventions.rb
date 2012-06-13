require 'spec_helper'
module WLang
  describe Template, 'call_args_conventions' do

    let(:template){ Template.new("Hello ${who}!") }

    subject{ template.send(:call_args_conventions, args.dup) }

    let(:scope) { subject.first }
    let(:buffer){ subject.last  }

    before do
      scope.should be_a(Scope)
      buffer.should respond_to(:<<)
    end

    context 'without any argument' do
      let(:args){ [] }
      it 'sets a default NullScope' do
        scope.should eq(Scope.null)
      end
      it 'uses a string buffer' do
        buffer.should eq('')
      end
    end

    context 'with only a String buffer' do
      let(:args){ [ 'foo' ] }
      it 'sets a default NullScope' do
        scope.should eq(Scope.null)
      end
      it 'uses the provided buffer' do
        buffer.should eq('foo')
      end
    end

    context 'with only a StringIO buffer' do
      let(:args){ [ StringIO.new ] }
      it 'sets a default NullScope' do
        scope.should eq(Scope.null)
      end
      it 'uses the provided buffer' do
        buffer.should eq(args.first)
        buffer.object_id.should eq(args.first.object_id)
      end
    end

    context 'with only a Hash' do
      let(:args){ [ {} ] }
      it 'sets the correct scope subjects' do
        scope.subjects.should eq(args)
      end
      it 'uses a string buffer' do
        buffer.should eq('')
      end
    end

    context 'with multiple scoping arguments' do
      let(:args){ [ 12, {} ] }
      it 'builds a chain of scoping arguments' do
        scope.subjects.should eq(args)
      end
      it 'uses a string buffer' do
        buffer.should eq('')
      end
    end

    context 'with both a Hash and a String' do
      let(:args){ [ {}, 'foo' ] }
      it 'sets a default ObjectScope' do
        scope.subjects.should eq([args.first])
      end
      it 'uses a string buffer' do
        buffer.should eq('foo')
      end
    end

    context 'when the template has locals and no arguments' do
      let(:template){ Template.new(hello_with_data_path) }
      let(:args){ [] }
      it 'uses template locals in Scope' do
        scope.subjects.should eq([{"who" => "world"}])
      end
      it 'uses a string buffer' do
        buffer.should eq('')
      end
    end

    context 'when the template has locals and arguments' do
      let(:template){ Template.new(hello_with_data_path) }
      let(:args){ [ 12, {}, 'foo' ] }
      it 'sets the correct scoping subjects' do
        scope.subjects.should eq([12, {}, {"who" => "world"}])
      end
      it 'uses the string as buffer' do
        buffer.should eq('foo')
      end
    end

  end
end