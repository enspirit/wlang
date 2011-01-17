# Installs a rake task for generating the specification.
desc "Generate doc/specification/specification.html"
task :genspec do
  Kernel.exec("ruby -Ilib bin/wlang --methodize --output doc/specification/specification.html doc/specification/specification.wtpl")
end
