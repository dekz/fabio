class Executor
  def initialize(app)
    @app   = app
  end

  def call(env)
    puts "I shall exec #{env[:exec]}"
    @app.call(env)
  end
end
