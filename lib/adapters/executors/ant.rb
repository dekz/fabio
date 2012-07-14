module Executor
  class Ant
    def initialize(app)
      @app   = app
    end

    def call(env)
      perform env if env[:exec] == 'ant'
      @app.call(env)
    end

    def perform args
      `ant`
    end
  end
end
