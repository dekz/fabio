class Git
  def initialize(app)
    @app   = app
  end

  def call(env)
    perform_git_op(env[:repository]) if env[:repository][:type] == 'git'
    @app.call(env)
  end

  def perform_git_op args
    repo = args
    op = repo[:operation] || 'clone'
    git_args = repo[:options] if repo.member? :options
    path = repo[:path]
    `git #{git_args} #{op} #{path}`
  end
end
