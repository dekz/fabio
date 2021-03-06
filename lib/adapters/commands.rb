require 'middleware'
require 'adapters/worker_stack'
require 'adapters/commands/ping'
require 'adapters/commands/info'

class Commands < WorkerStack
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Command::Ping
      use Command::Info
    end
  end

  def call env
    run_env(env, :cmd) do |z|
      if env[:env][:cmd].is_a? String
        z[:env] = { :type => z[:env] }
      end
      @stack.call(z)
    end

    @app.call env
  end
end
