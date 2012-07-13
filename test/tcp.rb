require 'socket'
require 'middleware'
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'adapters/commands')
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'adapters/executors')
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'adapters/repositories')
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'adapters/reporters')

server = TCPServer.new 3333
loop do

  client = server.accept
  cmd =  client.readline
  cmd = cmd.strip

  stack = Middleware::Builder.new do
    use Commands
    use Repositories
    use Executors
    use Reporters
  end

  stack.call({ :cmd => cmd.to_sym })
end
