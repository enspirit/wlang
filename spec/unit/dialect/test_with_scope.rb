require 'spec_helper'
module WLang
  class Dialect
    describe Evaluation, "with_scope" do
      include Evaluation

      let(:struct){ Struct.new(:who) }

      it 'returns the block value' do
        got = with_scope({:who => "World"}) do
          12
        end
        got.should eq(12)
      end

    end # describe Evaluation, "with_scope"
  end # class Dialect
end # module WLang
