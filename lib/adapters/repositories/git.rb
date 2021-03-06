require 'command-builder'

module Repository
  class Git
    autoload :Executor, 'adapters/executors'
    include Fabio::Logger
    include Executor

    def initialize(app)
      @app   = app
    end

    def call(env)
      log :git_before, :debug
      repos = env[:env]
      perform(repos) if repos[:type] == 'git'
      @app.call(env)
      log :git_end, :debug
    end

    def perform args
      repo = args
      op = repo[:operation].to_s || 'clone'
      git_args = repo.member?(:options) ? repo[:options] : ''
      path = repo[:path] || ''
      out_dir = repo[:out_dir] || ''

      cmd = CommandBuilder.new(:git)

      cmd << git_args unless git_args.empty?
      cmd << op.to_s unless op.empty?
      cmd << path unless path.empty?
      cmd << out_dir unless (out_dir.empty? || op['pull'])

      result = fexec cmd.to_s, args[:working_dir]
    end
  end
end
