def clean_file(file)
  c = File.read(file)
  c.gsub!(/[ \t]+\n/, "\n")
  File.open(file, 'w'){|io|
    io << c
  }
end

Dir["**/*.rb"].each{|file| clean_file(file)}
Dir["**/*.yml"].each{|file| clean_file(file)}
Dir["**/*.md"].each{|file| clean_file(file)}
