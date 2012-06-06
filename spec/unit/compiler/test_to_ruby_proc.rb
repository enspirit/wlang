require 'spec_helper'
module WLang
  describe Compiler, 'to_ruby_proc' do

    def to_ruby_proc(source)
      Compiler.new(WLang::Dialect.new).to_ruby_proc(source)
    end

    it 'returns a proc even if no tag at all' do
      source   = "Hello world!"
      to_ruby_proc(source).should be_a(Proc)
    end

  end # describe Compiler, 'to_ruby_proc'
end # module WLang
