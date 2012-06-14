require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :"travis-lint" do
  sh "travis-lint"
end

task :default => [:"travis-lint", :spec]

