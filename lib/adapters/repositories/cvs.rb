module Repository
  class CVS
    autoload :Executor, File.join(File.expand_path(File.dirname(__FILE__)), '..', 'executors')
    include Fabio::Logger
    include Executor

    def initialize(app)
      @app   = app
    end

    def call(env)
      log :cvs_before, :type => :debug
      repos = env[:env]
      perform(repos) if repos[:type] == 'cvs'
      @app.call(env)
      log :cvs_end, :type => :debug
    end

    def perform args
      repo = args
      op = repo[:operation] || 'co'
      cvs_args = repo[:options] if repo.member? :options
      path = repo[:path]

      cmd = 'cvs'
      cmd << " #{cvs_args}" unless cvs_args.empty?
      cmd << " #{op}" unless op.empty?
      cmd << " #{path}" unless path.empty?

      fexec cmd
    end
  end
end
