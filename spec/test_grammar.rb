require 'spec_helper'
module WLang
  describe Grammar do
    
    let(:grammar){ WLang::Grammar }

    context "parsing" do
      
      subject{ 
        if defined?(trailing)
          grammar.parse(text, :root => rule, :consume => false) 
        else
          grammar.parse(text, :root => rule) 
        end
      }
      after { subject.should eq(text) }

      describe 'the fn_start rule' do
        let(:rule){ :fn_start }
        let(:text){ "{"       }
        it{ should_not be_nil }
      end

      describe 'the fn_stop rule' do
        let(:rule){ :fn_stop  }
        let(:text){ "}"       }
        it{ should_not be_nil }
      end
      
      describe 'the symbols rule' do
        let(:rule){ :symbols }
        WLang::SYMBOLS.each do |sym|
          describe 'on #{sym}' do
            let(:text){ sym }
            it{ should_not be_nil }
          end
        end
        describe 'on "<<+"' do
          let(:text){ "<<+"     }
          it{ should_not be_nil }
        end
        describe 'on joined symbols' do
          let(:text){ WLang::SYMBOLS.join }
          it{ should_not be_nil }
        end
      end
      
      describe 'the stop char rule' do
        let(:rule){ :stop_char  }
        describe 'on {' do
          let(:text){ '{'         }
          it{ should_not be_nil   }
        end
        describe 'on }' do
          let(:text){ '}'         }
          it{ should_not be_nil   }
        end
        describe 'on ${' do
          let(:text){ '${'        }
          it{ should_not be_nil   }
        end
        describe 'on <<+{' do
          let(:text){ '<<+{'      }
          it{ should_not be_nil   }
        end
      end

      describe 'the block rule' do
        let(:rule){ :block      }
        let(:text){ '{ hello }' }
        it{ should_not be_nil   }
      end
          
      describe 'the wlang rule' do
        let(:rule){ :wlang      }
        describe 'on a single wlang block' do
          let(:text){ '${who}'    }
          it{ should_not be_nil   }
        end
        describe 'on a wlang with two blocks' do
          let(:text){ '${who}{,}' }
          it{ should_not be_nil   }
        end
      end
      
      describe 'the static rule' do
        let(:rule){ :static       }
        describe 'on pure static text' do
          let(:text){ 'Hello world' }
          it{ should_not be_nil     }
        end
        describe 'with trailing chars' do
          let(:text){ 'Hello '       }
          let(:trailing){ "${who}"   }
          it{ should_not be_nil      }
        end
      end
      
      describe 'the non_static rule on a block' do
        describe 'on a block' do
          let(:rule){ :non_static   }
          let(:text){ '{ hello }'   }
          it{ should_not be_nil     }
        end
        describe 'on a wlang' do
          let(:rule){ :non_static   }
          let(:text){ '${who}'      }
          it{ should_not be_nil     }
        end
      end

      describe 'the concat rule' do
        let(:rule){ :concat        }
        let(:text){ 'Hello ${who}' }
        it{ should_not be_nil      }
      end

      describe "the template rule" do
        let(:rule){ :template }
        describe 'on an empty template' do
          let(:text){ "" }
          it{ should_not be_nil }
        end
        describe 'on a static template' do
          let(:text){ "Hello world" }
          it{ should_not be_nil }
        end
        describe 'on a block' do
          let(:text){ "{ world }" }
          it{ should_not be_nil }
        end
        describe 'on a wlang' do
          let(:text){ "${who}" }
          it{ should_not be_nil }
        end
        describe 'on a high-order wlang' do
          let(:text){ "${${who}}" }
          it{ should_not be_nil }
        end
        describe 'on a mix' do
          let(:text){ "Hello ${who}!" }
          it{ should_not be_nil }
        end
      end

    end
    
    context "value" do
      
      subject{ grammar.parse(text, :root => rule).value }
      
      describe 'the static rule' do
        let(:rule){ :static }
        let(:text){ "Hello world!" }
        it{ should eq([:static, text]) }
      end
      
      describe 'the block rule' do
        let(:rule){ :block }
        let(:text){ "{ world }" }
        it{ should eq([:static, text]) }
      end
      
      describe 'the wlang rule' do
        let(:rule){ :wlang }
        let(:text){ "${who}" }
        it{ should eq([:wlang, '$', [:fn, [:static, "who"]] ]) }
      end
      
      describe 'concat rule' do
        let(:rule){ :concat }
        describe "when a single match" do
          let(:text){ "Hello world" }
          it{ should eq([:static, text]) }
        end
        describe "with multiple matches" do
          let(:text){ "Hello ${who}!" }
          specify{ 
            expected = \
              [:concat, 
                [:static, "Hello "],
                [:wlang, '$', [:fn, [:static, "who"]]],
                [:static, "!"]
              ]
            subject.should eq(expected)
          }
        end
      end
      
    end
    
  end
end