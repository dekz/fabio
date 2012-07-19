module Executor
  class Rake
    include Executor
    def initialize(app)
      @app   = app
    end

    def call(env)
      perform(env[:env]) if env[:env][:type] == 'rake'
      @app.call(env)
    end

    def perform args

      working_dir = args[:working_dir] || ''
      path_to_rake = args[:rake_path]
      rake_args = args[:args] || ''
      target = args[:target] || ''

      fexec "cd #{working_dir} && #{path_to_rake} rake #{rake_args} #{target}"
    end
  end
end
