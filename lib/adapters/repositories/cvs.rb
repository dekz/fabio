module Repository
  class CVS
    def initialize(app)
      @app   = app
    end

    def call(env)
      perform(env[:repository]) if env[:repository][:type] == 'cvs'
      @app.call(env)
    end

    def perform args
      repo = args
      op = repo[:operation] || 'co'
      cvs_args = repo[:options] if repo.member? :options
      path = repo[:path]
      `cvs #{cvs_args} #{op} #{path}`
    end
  end
end
