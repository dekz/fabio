require 'middleware'
require File.join(File.dirname(__FILE__), 'worker_stack')
require File.join(File.dirname(__FILE__), 'environments/bundler')

class Environments < WorkerStack
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Environment::Bundler
    end
  end

  def call env
    puts "--> Environments"

    run_env(env, :environment) do |z|
      @stack.call(z)
    end

    @app.call env
    puts "<-- Environments"
  end
end
