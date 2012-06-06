require 'spec_helper'
module WLang
  describe Template, 'to_ast' do

    let(:template){ Template.new("Hello ${who}!") }

    it 'it returns an ast' do
      template.to_ast.should be_a(Array)
    end

  end
end