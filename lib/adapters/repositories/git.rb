module Repository
  class Git
    autoload :Executor, File.join(File.expand_path(File.dirname(__FILE__)), '..', 'executors')
    include Fabio::Logger
    include Executor

    def initialize(app)
      @app   = app
    end

    def call(env)
      log :git_before, :type => :debug
      repos = env[:env]
      perform(repos) if repos[:type] == 'git'
      @app.call(env)
      log :git_end, :type => :debug
    end

    def perform args
      repo = args
      op = repo[:operation] || 'clone'
      git_args = repo[:options] if repo.member? :options
      path = repo[:path]
      fexec "git #{git_args} #{op} #{path}"
    end
  end
end
