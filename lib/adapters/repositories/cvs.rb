class CVS
  def initialize(app)
    @app   = app
  end

  def call(env)
    perform_cvs_op(env[:repository]) if env[:repository][:type] == 'cvs'
    @app.call(env)
  end

  def perform_cvs_op args
    repo = args
    op = repo[:operation] || 'co'
    cvs_args = repo[:options] if repo.member? :options
    path = repo[:path]
    `cvs #{cvs_args} #{op} #{path}`
  end
end
