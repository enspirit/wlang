require 'spec_helper'
module WLang
  describe Dialect::Tags do

    describe 'tag' do
      include Dialect::Tags::ClassMethods

      def define_tag_method(*args)
        args
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
    end

  end # describe Dialect
end # module WLang
