module WLang
  class Dialect
    describe Scoping do
      include Scoping
      
      context 'with :strict' do
        scoping :strict
        
        it 'uses Strict' do
          with_scope(1){ 
            with_scope(2){
              each_scope.to_a.should eq([2]) 
            }
          }
        end
      end
      
      context 'with :stack' do
        scoping :stack
        
        it 'uses Stack' do
          with_scope(1){ 
            with_scope(2){
              each_scope.to_a.should eq([2, 1]) 
            }
          }
        end
      end
      
    end # describe Scoping
  end # class Dialect
end # module WLang