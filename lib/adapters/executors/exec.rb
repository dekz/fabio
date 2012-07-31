module Executor
  class DefaultExecutor
    include Fabio::Logger
    include Executor

    def initialize(app)
      @app   = app
    end

    def call(env)
      perform(env[:exec]) if env[:exec] == 'exec'
      @app.call(env)
    end

    def perform args
      resp = fexec args
    end
  end
end
