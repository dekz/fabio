module Command
  class Ping
    def initialize(app)
      @app = app
    end

    def call(env)
      perform(env) if env[:env][:type].to_s == :ping
      @app.call env
    end

    def perform args
      puts 'Pong!'
    end
  end
end
