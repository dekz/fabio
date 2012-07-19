module Executor
  class Ant
    include Executor
    def initialize(app)
      @app   = app
    end

    def call(env)
      perform(env[:env]) if env[:env][:type] == 'ant'
      env[:out].write 'a' if env.member? :out
      @app.call(env)
    end

    def perform args
      if args.is_a? String
        fexec args
      elsif
        path_to_ant = args[:ant_path]
        ant_args = args[:args] || ''
        target = args[:target] || 'build'
        fexec "#{path_to_ant} #{ant_args} #{target}"
      end
    end
  end
end
