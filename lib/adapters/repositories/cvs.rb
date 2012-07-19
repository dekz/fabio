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
      p repos
      perform(repos) if repos[:type] == 'cvs'
      @app.call(env)
      log :cvs_end, :type => :debug
    end

    def perform args
      repo = args
      op = repo[:operation] || 'co'
      cvs_args = repo.member?(:options) ? repo[:options] : ''
      path = repo[:path]

      cmd = CommandBuilder.new(:cvs)
      cmd << op
      cmd << path
      cmd << cvs_args unless cvs_args.empty?
      cmd << :P if cvs_args.empty?

      fexec cmd.to_s
    end
  end
end
