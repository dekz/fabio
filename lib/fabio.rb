require 'middleware'
require 'uuid'

autoload :Commands, File.join(File.expand_path(File.dirname(__FILE__)), 'adapters/commands')
autoload :Repositories, File.join(File.expand_path(File.dirname(__FILE__)), 'adapters/repositories')
autoload :Executors, File.join(File.expand_path(File.dirname(__FILE__)), 'adapters/executors')
autoload :Reporters, File.join(File.expand_path(File.dirname(__FILE__)), 'adapters/reporters')

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
        use Repositories
        use Executors
        use Reporters
      end

      io = StringIO.new
      env = { :env => env, :out => io }
      stack.call env
    end
  end
end
