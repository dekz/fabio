module Environment
  class Bundler
    autoload :Executor, File.join(File.expand_path(File.dirname(__FILE__)), '..', 'executors')
    include Fabio::Logger
    include Executor

    def initialize(app)
      @app   = app
    end

    def call(env)
      log :bundler_before, :type => :debug
      p env
      if env[:env][:type] == 'bundler'
        perform(env[:env]) unless env[:env][:args] == 'install'
        @app.call(env)
        perform(env[:env]) if env[:env][:args] == 'package'
      end
      log :bundler_end, :type => :debug
    end

    def perform args
      working_dir = args[:working_dir] || ''
      target = args[:args] || ''
      fexec "#{"cd #{working_dir} && " unless working_dir.empty?} bundle #{target}"
    end
  end
end
