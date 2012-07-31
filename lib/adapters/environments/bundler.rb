require 'command-builder'
module Environment
  class Bundler
    autoload :Executor, 'adapters/executors'
    include Fabio::Logger
    include Executor

    def initialize(app)
      @app   = app
    end

    def call(env)
      log :bundler_before, :type => :debug
      if env[:env][:type] == 'bundler'
        perform(env[:env]) if env[:env][:args] == 'install'
        @app.call(env)
        perform(env[:env]) if env[:env][:args] == 'package'
      end
      log :bundler_end, :type => :debug
    end

    def perform args

      bundle = CommandBuilder.new(:bundle)
      bundle << args[:args] || 'install'

      fexec bundle.to_s, args[:working_dir]
    end
  end
end
