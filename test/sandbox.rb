Dir["**/*_test.rb"].collect do |file|
  next if /\.svn/ =~ file
  begin
    load(file)
  rescue Exception => ex
    puts "Unable to load test file #{file}: #{ex.message}"
  end
end
