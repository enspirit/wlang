module WLang

  describe HashScope, "respond_to?" do

    let(:h){ HashScope.new(:name => "WLang", "who" => "World") }

    it 'responds on keys' do
      h.respond_to?(:name).should be_true
      h.respond_to?(:who).should be_true
    end

    it 'responds existing methods' do
      h.respond_to?(:has_key?).should be_true
    end

    it 'does not respond to missing ones' do
      h.respond_to?(:no_such_one).should be_false
    end

  end # HashScope

  describe HashScope, "method_missing" do

    let(:h){ 
      HashScope.new(:name => "WLang", "who" => "World", 
                    :keys => "", "puts" => "puts", 
                    :sub => { :name => "SubHash" }) 
    }

    it 'returns on keys' do
      h.name.should eq("WLang")
      h.who.should eq("World")
    end

    it 'returns on existing methods' do
      h.has_key?(:name).should be_true
      h.has_key?(:no_such_one).should be_false
    end

    it 'uses hash keys in priority' do
      h.keys.should eq("")
    end

    it 'automatically scopes sub hashes' do
      h.sub.name.should eq("SubHash")
    end

    it 'overrides private Object methods' do
      h.puts.should eq("puts")
    end

    it 'does not respond on missing ones' do
      lambda{h.no_such_one}.should raise_error(NoMethodError)
    end

  end # HashScope

end # module WLang
