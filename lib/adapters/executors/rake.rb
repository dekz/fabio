require 'command-builder'
module Executor
  class Rake
    include Executor
    def initialize(app)
      @app   = app
    end

    def call(env)
      p perform(env[:env]) if env[:env][:type] == 'rake'
      @app.call(env)
    end

    def perform args

      cd = CommandBuilder.new(:cd)
      cd << args[:working_dir] if args.member? :working_dir

      rake = CommandBuilder.new((args[:rake_path] || :rake))
      rake << args[:args] if args.member? :args
      rake << args[:target] if args.member? :target

      cmd = ''
      cmd << "#{cd.to_s} && " unless cd.params.empty?
      cmd << rake.to_s

      fexec cmd
    end
  end
end
