module Command
  class Info
    def initialize(app)
      @app = app
    end

    def call(env)
      p env
      perform(env) if env[:env][:type] == 'info'
      @app.call env
    end

    def perform env
      puts 'Info' 
      env[:out].write 'Info!' if env.member? :out
    end
  end
end
