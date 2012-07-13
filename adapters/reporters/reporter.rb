class Reporter
  def initialize(app)
    @app = app
  end

  def call(env)
    puts 'Reporting!' if env[:cmd] == :ping
    @app.call env
  end
end
