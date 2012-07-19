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
      ant = CommandBuilder.new(:ant)
      if args.is_a? String
        return fexec ant.to_s
      end

      cd = CommandBuilder.new(:cd)
      cd << args[:working_dir] if args.member? :working_dir

      # Load ant through ant_home with java specified
      if args.member? :java_home
        ant.command = args[:java_home]
        orig_sep = ant.separators[2]
        ant.separators[2] = ''
        ant.argument("-Dant.home=#{args[:ant_home]}")
        ant << 'org.apache.tools.ant.Main'
      else
        ant.command = (args[:ant_path] || :ant)
      end

      ant << args[:args] if args.member? :args
      if args.member? :buildfile
        ant << :f
        ant << args[:buildfile]
      end
      ant << args[:target] if args.member? :target

      cmd = ''
      cmd << "#{cd.to_s} && " unless cd.params.empty?
      cmd << "ANT_OPTS=#{args[:opts]} " if args.member? :opts
      cmd << ant.to_s

      fexec cmd
    end
  end
end
