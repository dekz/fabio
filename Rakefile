task :default => [:test]
task 'test' do
  begin
    load './test/test.rb'
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
