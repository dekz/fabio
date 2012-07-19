require 'middleware'
require File.join(File.dirname(__FILE__), 'worker_stack')
require File.join(File.dirname(__FILE__), 'repositories/cvs')
require File.join(File.dirname(__FILE__), 'repositories/git')

class Repositories < WorkerStack
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Repository::CVS
      use Repository::Git
    end
  end

  def call env
    puts "--> Repositories"

    run_env(env, :repository) do |z|
      @stack.call(z)
    end

    @app.call env
    puts "<-- Repositories"
  end
end
