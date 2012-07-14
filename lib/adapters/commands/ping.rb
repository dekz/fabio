module Command
  class Ping
    def initialize(app)
      @app = app
    end

    def call(env)
      puts 'Pong!' if env[:cmd] == :ping
      @app.call env
    end
  end
end
