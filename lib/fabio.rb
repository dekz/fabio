require 'middleware'
require 'uuid'
require 'stringio'
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../lib'))

autoload :Commands, 'adapters/commands'
autoload :Repositories, 'adapters/repositories'
autoload :Environments, 'adapters/environments'
autoload :Executors, 'adapters/executors'
autoload :Reporters, 'adapters/reporters'

module Fabio

  module Logger
    def log(msg, type={:type => 'info'})
      puts "#{type[:type]}: #{msg}"
    end
    module_function :log
  end

  class Worker
    include Logger

    def call(env)
      env[:uuid] =  UUID.new.generate
      env.freeze
      log "Fabio: #{env[:uuid]}"

      stack = Middleware::Builder.new do
        use Commands
        use Environments
        use Repositories
        use Executors
        use Reporters
      end

      io = StringIO.new
      env = { :env => env, :out => io }
      stack.call env
      env[:out].rewind
      p env
      puts "Out: #{env[:out].read}"
    end
  end
end
