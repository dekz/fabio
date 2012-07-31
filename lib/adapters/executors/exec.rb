module Executor
  class DefaultExecutor
    include Logger
    include Executor

    def initialize(app)
      @app   = app
    end

    def call(env)
      log "I shall exec #{env[:exec]}" if env[:exec] == 'exec'
      perform(env[:exec])
      @app.call(env)
    end

    def perform args
      resp = fexec args
    end
  end
end
