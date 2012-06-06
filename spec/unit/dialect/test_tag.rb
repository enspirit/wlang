require 'spec_helper'
module WLang
  describe Dialect, 'tag' do

    let(:dialect){ Class.new(Dialect) }

    before do
      def dialect.define_tag_method(*args)
        args
      end
    end

    def tag(*args, &bl)
      dialect.tag(*args, &bl)
    end

    it "works with a symbol" do
      tag("$", :dollar).should eq(["$", nil, :dollar])
    end

    it "works with a single proc" do
      proc = lambda{|buf,fn| }
      tag("$", &proc).should eq(["$", nil, proc])
    end

    it "allows specifying dialects with a symbol" do
      tag("$", [Foo], :dollar).should eq(["$", [Foo], :dollar])
    end

    it "allows specifying dialects with a proc" do
      proc = lambda{|buf,fn| }
      tag("$", [Foo], &proc).should eq(["$", [Foo], proc])
    end

  end # describe Dialect
end # module WLang
