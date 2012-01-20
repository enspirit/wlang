require File.expand_path('../commons', __FILE__)

MUSTACHE = <<-EOF
<table>
  {{#people}}
    <tr>
      <td>{{name}}</td>
      <td>{{score}}</td>
    </tr>
  {{/people}}
</table>
EOF

MUSTANG = <<-EOF
<table>
  *{people}{
    <tr>
      <td>${name}</td>
      <td>${score}</td>
    </tr>
  }
</table>
EOF

TERB = <<-EOF
<table>
  <% people.each do |p| %>
    <tr>
      <td><%= p.name %></td>
      <td><%= p.score %></td>
    </tr>
  <% end %>
</table>
EOF

max = 20000
mustang, mustache, erb = nil, nil, nil
People = Struct.new(:name, :score)
Benchmark.bm(10) do |x|
  people = (1..max).map{|i| People.new("People#{i}", rand)}
  scope  = {:people => people}
  x.report("mustang"){
    mustang = WLang::Mustang.render(MUSTANG, scope)
  }
  x.report("mustache"){
    mustache = Mustache.render(MUSTACHE, scope)
  }
  x.report("erb"){
    erb = ERB.new(TERB).result(binding)
  }
end

# puts mustang
# puts mustache
# puts erb
