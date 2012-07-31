require 'rspec/core/rake_task'
task :default => [:test]
task 'test' do
  begin
    RSpec::Core::RakeTask.new do |t|
      t.pattern = "*.rb"
    end
  rescue Exception => e
    p e
  end
end

task 'test:git' do
  begin
    load './test/git.rb'
  rescue Exception => e
    p e
  end
end

task 'empty' do
  puts 'empty'
end
