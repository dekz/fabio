class CVS
  def initialize(app)
    @app   = app
  end

  def call(env)
    puts "I should get a CVS repo"
    @app.call(env)
  end
end
