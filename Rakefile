require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files  = FileList['test/test_helper.rb', 'test/test_*.rb']
  t.warning = true
end

desc "Run tests"
task :default => :test