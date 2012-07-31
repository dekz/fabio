require 'middleware'

require 'adapters/worker_stack'
require 'adapters/repositories/cvs'
require 'adapters/repositories/git'

class Repositories < WorkerStack
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Repository::CVS
      use Repository::Git
    end
  end

  def call env
    run_env(env, :repository) do |z|
      @stack.call(z)
    end

    @app.call env
  end
end
