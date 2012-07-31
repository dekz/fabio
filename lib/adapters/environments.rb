require 'middleware'
require 'adapters/worker_stack'
require 'adapters/environments/bundler'

class Environments < WorkerStack
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Environment::Bundler
    end
  end

  def call env
    run_env(env, :environment) do |z|
      @stack.call(z)
    end

    @app.call env
  end
end
