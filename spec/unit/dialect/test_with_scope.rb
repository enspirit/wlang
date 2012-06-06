require 'spec_helper'
module WLang
  describe Dialect, 'with_scope' do

    let(:struct){ Struct.new(:who) }

    it 'returns the block value' do
      got = Dialect.new.with_scope({:who => "World"}) do
        12
      end
      got.should eq(12)
    end

  end # describe Dialect, 'with_scope'
end # module WLang
