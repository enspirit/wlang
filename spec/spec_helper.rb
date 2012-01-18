require 'epath'
root = Path.backfind('.[Rakefile]')

$LOAD_PATH.unshift root/:lib
$LOAD_PATH.unshift root/:spec

require 'wlang'

(root/:spec).glob("fixtures/dialect/*.rb").each do |f|
  require f.expand_path
end
