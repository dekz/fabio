module Repository
  class CVS
    autoload :Executor, 'adapters/executors'
    include Fabio::Logger
    include Executor

    def initialize(app)
      @app   = app
    end

    def call(env)
      log :cvs_before, :type => :debug
      perform(env[:env]) if env[:env][:type] == 'cvs'
      @app.call(env)
      log :cvs_end, :type => :debug
    end

    def perform args
      repo = args
      op = repo[:operation] || 'co'
      cvs_args = repo.member?(:options) ? repo[:options] : ''
      path = repo[:path]

      cmd = CommandBuilder.new(:cvs)
      cmd << cvs_args unless cvs_args.empty?
      cmd << op
      cmd << path
      cmd << :P if cvs_args.empty?

      result = fexec cmd.to_s, args[:working_dir]
    end
  end
end
