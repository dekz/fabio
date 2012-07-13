class Info
  def initialize(app)
    @app = app
  end

  def call(env)
    puts 'Info' if env[:cmd] == :info
    @app.call env
  end
end
