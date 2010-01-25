require 'test/unit'
require 'wlang'
module WLang

  # Tests the IntelligentBuffer class
  class IntelligentBufferTest < Test::Unit::TestCase
    include IntelligentBuffer::Methods
    
    # Creates a buffer instance
    def buffer(str)
      IntelligentBuffer.new(str)
    end
    
    def test_last_column
      assert_equal(4, last_column('abc'))
      assert_equal(4, last_column("\nabc"))
      assert_equal(6, last_column("\nabc\nab cd"))
      assert_equal(1, last_column("\n\n\n\n\n\n"))
    end
    
    def test_ismultiline?
      assert is_multiline?("\n")
      assert is_multiline?("\nabc")
      assert is_multiline?("\nabc\n")
      assert_equal false, is_multiline?("abc")
      assert_equal false, is_multiline?("abc\t")
    end
    
    def test_tabto
      template = <<-EOF
        def +{d}
          contents of the method here
          and also here
        end
      EOF
      template = tabto(template, 0).strip
      assert_equal("def +{d}\n  contents of the method here\n  and also here\nend", template)
      # check on normal multiline
      template = %Q{
        def +{d}
          contents of the method here
          and also here
        end
      }
      stripped = strip_block(template)
      expected = "    def +{d}\n      contents of the method here\n      and also here\n    end\n"
      assert_equal(expected, tabto(stripped, 4))
    end
    
    def test_strip_block
      # check on non multiline
      assert_equal 'abc', strip_block('abc')
      
      # check on normal multiline
      template = %Q{
        def +{d}
          contents of the method here
          and also here
        end
      }
      expected = "        def +{d}\n          contents of the method here\n          and also here\n        end\n"
      assert_equal(expected, strip_block(template))

      # check that explicit carriage return are recognized
      template = %Q{

        def +{d}
          contents of the method here
          and also here
        end
      }
      expected = "\n        def +{d}\n          contents of the method here\n          and also here\n        end\n"
      assert_equal(expected, strip_block(template))

      # check that no first carriage return is recognized as well
      template = %Q{def +{d}
  contents of the method here
  and also here
end
      }
      expected = "def +{d}\n  contents of the method here\n  and also here\nend\n"
      assert_equal(expected, strip_block(template))
      
      # Check on push failure
      template = %Q{

    def hello()
    end
  }
      assert_equal("\n    def hello()\n    end\n", strip_block(template))

      # Tests on a missing end bug
      mod = "module MyModule\n  10\n  20\n  30\n\nend"
      assert_equal(mod, strip_block(mod))
    end
    
    def test_missing_end_bug_reason
      buf = IntelligentBuffer.new
      mod = "module MyModule\n  10\n  20\n  30\n\nend"
      assert_equal(mod, strip_block(mod))
      buf.<<(mod, true)
      assert_equal(mod, buf.to_s)
    end
    
    def test_push
      template = <<-EOF
        module +{name}
          
          *{defs as d}{
            
            def +{d}
            end
          }
          
        end
      EOF
      #puts template.gsub(/ {8}/, '').strip
      buf = buffer('')
      buf.<<("module ", false)
      buf.<<("MyModule", true)
      buf.<<("\n\n  ", false)
        bufit = buffer('')
          buf2 = buffer('')
          buf2.<<("\n\n    def ", false)
            buf3 = buffer('')
            buf3.<<('hello', true)
          buf2.<<(buf3.to_s, true)
          buf2.<<("()\n    end\n  ", false)
          #puts "\nAppending on bufit, first iteration"
          #puts "|#{buf2.to_s}|"
        bufit.<<(buf2.to_s, true)
          #puts "\nAfter append"
          #puts "|#{bufit.to_s}|"
          #puts "Last column is now #{last_column(bufit)}"
          buf2 = buffer('')
          buf2.<<("\n\n    def ", false)
            buf3 = buffer('')
            buf3.<<('strip', true)
          buf2.<<(buf3.to_s, true)
          buf2.<<("()\n    end\n  ", false)
          #puts "\nAppending on bufit, second iteration"
          #puts "|#{buf2.to_s}|"
        bufit.<<(buf2.to_s, true)
          #puts "\nAfter append"
          #puts "|#{bufit.to_s}|"
      #puts "\nAppending bufit on buf"
      #puts "|#{buf.to_s}|"
      buf.<<(bufit.to_s, true)
      #puts "\nAfter append"
      #puts "|#{buf.to_s}|"
      buf.<<("\n\nend", false)
      #puts "\nNow, we've done"
      #puts buf
      expected = "module MyModule\n\n  def hello()\n  end\n  \n  def strip()\n  end\n\n\nend"
      assert_equal(expected, buf.to_s)
    end
    
    def test_wlang_on_intelligent_buffer
      template = <<-EOF
        module +{name}
          
          *{defs as d}{
            
            def +{d}
            end
          }
          
        end
      EOF
      template = template.gsub(/ {8}/, '').strip
      #puts template
      context = {"name" => "MyModule", "defs" => ["hello", "strip", "toeol"]}
      #puts template.wlang_instantiate(context, "wlang/ruby")
    end
    
    def test_wlang_on_web_example
      template = %q{
        <table>
          *{rows as r}{
            <tr>
              *{r as d}{
                <td>+{d}</td>
              }
            </tr>
          }
        </table>
      }.gsub(/^ {8}/, '').strip
      #puts template
      context = {"rows" => [[10, 11, 12], [20, 21, 22], [30, 31, 32]]}
      #puts template.wlang_instantiate(context, "wlang/xhtml")
    end    
    
  end # class IntelligentBufferTest
end