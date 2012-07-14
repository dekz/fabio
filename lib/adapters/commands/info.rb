module Command
  class Info
    def initialize(app)
      @app = app
    end

    def call(env)
      puts 'Info' if env[:cmd] == :info
      env[:out].write 'Info!' if env.member? :out
      @app.call env
    end
  end
end
