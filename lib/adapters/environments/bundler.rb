require 'command-builder'
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
        perform(env[:env]) if env[:env][:args] == 'install'
        @app.call(env)
        perform(env[:env]) if env[:env][:args] == 'package'
      end
      log :bundler_end, :type => :debug
    end

    def perform args
      cd = CommandBuilder.new(:cd)
      cd << args[:working_dir] if args.member? :working_dir

      bundle = CommandBuilder.new(:bundle)
      bundle << args[:args] || 'install'

      cmd = ''
      cmd << "#{cd.to_s} && " unless cd.params.empty?
      cmd << bundle.to_s

      fexec cmd.to_s
    end
  end
end
