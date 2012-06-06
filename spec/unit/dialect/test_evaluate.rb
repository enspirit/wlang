require 'spec_helper'
module WLang
  describe Dialect, 'evaluate' do

    let(:struct){ Struct.new(:who) }

    let(:dialect){ Dialect.new }

    def with_scope(*args, &bl)
      dialect.with_scope(*args, &bl)
    end

    def evaluate(*args, &bl)
      dialect.evaluate(*args, &bl)
    end

    it 'works with a hash' do
      with_scope({:who => "World"}) do
        evaluate("who").should eq("World")
        evaluate(:who).should eq("World")
      end
    end

    it 'works with a struct' do
      with_scope(struct.new("World")) do
        evaluate("who").should eq("World")
        evaluate(:who).should eq("World")
      end
    end

    it 'uses the hash in priority' do
      with_scope({:keys => [1,2,3]}) do
        evaluate("keys").should eq([1,2,3])
      end
    end

    it 'falls back to send' do
      with_scope({:who => "World"}) do
        evaluate("keys").should eq([:who])
      end
    end

    it 'raises a NameError when not found' do
      lambda{ evaluate("who") }.should raise_error(NameError)
    end

  end # describe Dialect, 'evaluate'
end # module WLang