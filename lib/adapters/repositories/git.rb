require 'command-builder'
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
      git_args = repo.member?(:options) ? repo[:options] : ''
      path = repo[:path] || ''
      out_dir = repo[:out_dir] || ''

      cmd = CommandBuilder.new(:git)

      cmd << git_args unless git_args.empty?
      cmd << op unless op.empty?
      cmd << path unless path.empty?
      cmd << out_dir unless out_dir.empty?

      fexec cmd.to_s
    end
  end
end
