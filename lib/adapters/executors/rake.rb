require 'command-builder'
module Executor
  class Rake
    include Executor
    def initialize(app)
      @app   = app
    end

    def call(env)
      perform(env) if env[:env][:type] == 'rake'
      @app.call(env)
    end

    def perform env
      args = env[:env]

      rake = CommandBuilder.new((args[:rake_path] || :rake))
      rake << args[:args] if args.member? :args
      if args.member? :rakefile
          rake << :f
          rake << args[:rakefile]
      end
      rake << args[:target] if args.member? :target

      # Prefix RVM here if it's available in global env
      cmd = ''
      cmd << "#{args[:env_args]} " if args.member? :env_args
      cmd << rvm_prefix(env)
      cmd << rake.to_s

      status = fexec(cmd, args[:working_dir]) do |pout,perr,pin,pid|
        env[:out] << pout.read
      end
    end

    def rvm_prefix env
      rvm_env = nil
      envs = env[:global][:environments]
      rvm_env = envs[:use] if envs.is_a?(Hash) && envs[:type] == 'rvm'
      rvm_env ||= envs.select { |e| e[:type] == 'rvm' }.first[:use] unless envs.is_a? Hash
      return '' unless rvm_env

      rvm = CommandBuilder.new(:rvm)
      rvm << rvm_env
      rvm << 'do'
      rvm.to_s + ' '
    end
  end
end
