require 'spec_helper'
module WLang
  describe FrontMatter, '.new' do

    let(:compiler){
      Object.new.extend(Module.new{
        def to_ruby_proc(x)
          x.upcase
        end
      })
    }

    subject{ FrontMatter.new(source, compiler) }

    describe 'when no front matter at all' do
      let(:source){ "Hello world!" }
      specify 'it should have empty locals' do
        subject.locals.should eq({})
      end
      specify 'it should have full template text' do
        subject.source_text.should eq(source)
      end
    end

    describe 'with a front matter' do
      let(:source){ "---\nlocals:\n  x: 2\n---\nHello world!" }
      specify 'it should have correct locals' do
        subject.locals.should eq({"x" => 2})
      end
      specify 'it should have full template text' do
        subject.source_text.should eq("Hello world!")
      end
    end

    describe 'with a front matter containing partials' do
      let(:source){ "---\npartials:\n  x: abc\n---\nHello world!" }
      specify 'it should have correct locals' do
        subject.locals.should eq({"x" => 'ABC'})
      end
      specify 'it should have full template text' do
        subject.source_text.should eq("Hello world!")
      end
    end

  end
end