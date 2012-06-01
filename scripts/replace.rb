require 'epath'
search, replace = ARGV
Dir["**/*.rb"].each do |file|
  c = Path(file).read
  rx = Regexp.new(search)
  if c =~ rx
    File.open(file, "w") do |io|
      io << c.gsub(rx, replace)
    end
  end
end
