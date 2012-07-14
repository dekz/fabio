module Executor
  class Executor
    def initialize(app)
      @app   = app
    end

    def call(env)
      puts "I shall exec #{env[:exec]}" if env[:exec] == 'exec'
      @app.call(env)
    end
  end
end
