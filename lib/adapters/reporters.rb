require 'middleware'

require 'adapters/reporters/reporter'

class Reporters < WorkerStack
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Reporter::StdOutReporter
    end
  end

  def call env
    run_env(env, :report) do |z|
      @stack.call(z)
    end

    @app.call env
  end
end
