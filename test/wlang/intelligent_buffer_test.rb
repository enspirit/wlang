require 'test/unit'
require 'wlang'
require 'wlang/intelligent_buffer'
module WLang

  # Tests the IntelligentBuffer class
  class IntelligentBufferTest < Test::Unit::TestCase
    include IntelligentBuffer::Utils
    
    # Creates a buffer instance
    def buffer(str)
      IntelligentBuffer.new(str)
    end
    
    def test_last_column
      assert_equal(4, last_column('abc'))
      assert_equal(4, last_column("\nabc"))
      assert_equal(6, last_column("\nabc\nab cd"))
    end
    
    def test_ismultiline?
      assert is_multiline?("\n")
      assert is_multiline?("\nabc")
      assert is_multiline?("\nabc\n")
      assert_equal false, is_multiline?("abc")
      assert_equal false, is_multiline?("abc\t")
    end
    
    def test_STRIP_BLOCK_REGEXP
      # check on non multiline
      assert_nil 'abc' =~ STRIP_BLOCK_REGEXP
      
      # check on normal multiline
      template = %Q{
        def +{d}
          contents of the method here
          and also here
        end
      }
      match2 = "        def +{d}\n          contents of the method here\n          and also here\n        end\n"
      match = template.match(STRIP_BLOCK_REGEXP)
      assert_equal "\n", match[1]
      assert_equal match2, match[2]
      assert_equal nil, match[3]
      assert_equal "        ", match[4]
      assert_equal "      ", match[5]
      
      # check that explicit carriage return are recognized
      template = %Q{
        
        def +{d}
          contents of the method here
          and also here
        end
      }
      match2 = "        \n        def +{d}\n          contents of the method here\n          and also here\n        end\n"
      match = template.match(STRIP_BLOCK_REGEXP)
      assert_equal match2, match[2]
      
      # check that no first carriage return is recognized as well
      template = %Q{def +{d}
          contents of the method here
          and also here
        end
      }
      match2 = "def +{d}\n          contents of the method here\n          and also here\n        end\n"
      match = template.match(STRIP_BLOCK_REGEXP)
      assert_equal match2, match[2]
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
      expected = "def +{d}\n  contents of the method here\n  and also here\nend\n"
      assert_equal(expected, strip_block(template))

      # check that explicit carriage return are recognized
      template = %Q{
        
        def +{d}
          contents of the method here
          and also here
        end
      }
      expected = "\ndef +{d}\n  contents of the method here\n  and also here\nend\n"
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
      assert_equal("\ndef hello()\nend\n", strip_block(template))
    end
    
    def test_realign
      # check on non multiline
      assert_equal 'abc', realign('abc', 10)
      
      # check on normal multiline
      template = %Q{
        def +{d}
          contents of the method here
          and also here
        end
      }
      stripped = strip_block(template)
      expected = "    def +{d}\n      contents of the method here\n      and also here\n    end\n"
      assert_equal(expected, realign(stripped, 4))
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
    
  end

end