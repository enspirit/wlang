namespace :test do
  require "rspec/core/rake_task"

  tests = []

  desc "Runs unit tests"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/test_*.rb"
    t.rspec_opts = ["-Ilib", "-Ispec", "--color", "--backtrace", "--format=progress"]
  end
  tests << :unit

  task :all => tests
end

desc "Runs all tests"
task :test => :'test:all'
