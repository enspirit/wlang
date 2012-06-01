require 'spec_helper'
require 'wlang/command'
module WLang
  describe "The examples" do

    (root_folder/:examples).glob("**/*.tpl").each do |ex_file|
      describe "the example file #{ex_file}" do

        let(:command) do
          cmd = WLang::Command.new
          def cmd.with_output(&proc); proc.call(""); end
          cmd
        end

        let(:expected) do
          Path.dir/:examples/ex_file.basename.sub_ext(".txt")
        end

        it 'is instantiated as expected with autospacing' do
          got = command.run ["--auto-spacing", ex_file]
          got.should eq(expected.read)
        end

      end
    end

  end
end