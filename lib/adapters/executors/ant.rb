module Executor
  class Ant
    include Executor
    def initialize(app)
      @app   = app
    end

    def call(env)
      perform env if env[:exec] == 'ant'
      @app.call(env)
    end

    def perform args
      path_to_ant = args[:ant_path] || 'ant'
      ant_args = args[:args] || ''
      target = args[:target] || 'build'
      p fexec "#{path_to_ant} #{ant_args} #{target}"
    end
  end
end
