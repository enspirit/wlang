class VirtualVar
  
  def initialize() @value = nil; end
  
  def []() @value end

  def []=(val) @value=val; end
      
end

v = VirtualVar.new
v[] = "hello"
puts v[]