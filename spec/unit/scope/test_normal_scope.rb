require 'spec_helper'
module WLang
  class Scope
    describe NormalScope do

      shared_examples_for "A NormalScope" do
        it 'evaluates correctly when found' do
          scope.evaluate('who').should eq("World")
        end
        it 'supports dot expressions' do
          scope.evaluate('who.upcase').should eq("WORLD")
        end
        it 'throws :fail when not found' do
          lambda{ scope.evaluate('nosuchone') }.should throw_symbol(:fail)
        end
        it 'implements frames accurately' do
          scope.frames.should eq([subject])
        end
      end

      let(:scope){ NormalScope.new(subject, RootScope.new) }

      context "on a hash" do
        let(:subject){ {:who => "World", :values => ""} }
        it_should_behave_like "A NormalScope"
        it 'falls back to hash methods' do
          scope.evaluate('keys').should eq([:who, :values])
        end
        it 'gives priority to keys' do
          scope.evaluate('values').should eq("")
        end
      end

      context "on a poro" do
        subject{ Struct.new(:who).new("World") }
        it_should_behave_like "A NormalScope"
      end

    end # describe NormalScope
  end # class Scope
end # module WLang
