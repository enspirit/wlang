require 'spec_helper'
module WLang
  class Dialect
    describe ClassMethods do
      include ClassMethods

      def define_method(name, &proc)
        @methods_defined ||= []
        @methods_defined << name
      end

      describe 'symbols2method' do

        it "works with a single char" do
          symbols2method("$").should eq(:_dynamic_36)
        end

        it "works with a multiple chars" do
          symbols2method("$$").should eq(:_dynamic_36_36)
        end

      end # symbols2method

      describe 'symbols2method' do
        
        it "works with a symbol" do
          rule("$", :execution)
          @methods_defined.should be_nil
          method_for("$").should eq(:execution)
        end
        
        it "works with a proc" do
          rule("$") do "Hello"; end
          @methods_defined.should eq([:_dynamic_36])
          method_for("$").should eq(:_dynamic_36)
        end
        
      end
      
    end
  end
end