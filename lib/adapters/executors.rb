require 'middleware'
require File.join(File.dirname(__FILE__), 'executors/exec')
require File.join(File.dirname(__FILE__), 'executors/ant')

class Executors
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Executor::Executor
      use Executor::Ant
    end
  end

  def call env
    puts "--> Executors"
    @stack.call env if env.member? :exec
    @app.call env
    puts "<-- Executors"
  end
end
