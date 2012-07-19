require 'middleware'
require File.join(File.dirname(__FILE__), 'worker_stack')
require File.join(File.dirname(__FILE__), 'commands/ping')
require File.join(File.dirname(__FILE__), 'commands/info')

class Commands < WorkerStack
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Command::Ping
      use Command::Info
    end
  end

  def call env
    puts "--> Commands"

    run_env(env, :cmd) do |z|
      @stack.call(z)
    end

    @app.call env
    puts "<-- Commands"
  end
end
