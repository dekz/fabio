require 'middleware'
require 'popen4'

require 'adapters/worker_stack'
require 'adapters/executors/exec'
require 'adapters/executors/ant'
require 'adapters/executors/rake'

module Executor

  class ExecutionError < Exception; end

  def fexec args, dir=nil
    resp = nil
    who_called = caller[0]
    exec_in_dir dir do
      # Call a block exec and yield pipes if block given
      return block_cmd(args) do |o,e,i,d|
        Fabio::Logger::log(("#{Dir.pwd}> " << args), :type => :exec)
        Fabio::Logger::log "#{d} >> #{who_called}", :type => :exec
        yield o,e,i,d
      end if block_given?

      # no block given, do a default reading stdout and stderr
      resp = default_cmd args
    end
    resp
  end
  module_function :fexec

  def exec_in_dir dir
    dir ||= Dir.pwd
    cwd = Dir.pwd 
    Dir.mkdir(dir) unless Dir.exists? dir
    Dir.chdir dir
    yield
    Dir.chdir cwd
  end

  def block_cmd cmd
    if block_given?
      return POpen4.popen4(cmd) { |o, e, i, d| yield o,e,i,d }
    end
  end

  ##
  # Default command executor, just print out stuff and
  # return an info object
  def default_cmd cmd
    return block_cmd(cmd) if block_given?
    begin
      err = nil
      stdout = nil
      Fabio::Logger::log(("#{Dir.pwd}> " << cmd), :type => :exec)
      status = block_cmd(cmd) do |pout, perr, pin, pid|
        err = perr.read
        stdout = pout.read
      end

      Fabio::Logger::log(err, :type => :stderr) unless err.empty?
      Fabio::Logger::log(stdout, :type => :stdout) unless stdout.empty?

      info = {
        :pid => status.pid,
        :stderr => err,
        :cmd => cmd,
        :stdout => stdout,
        :status => status.exitstatus
      }

      if !status.success?
        raise ExecutionError, info
      end

      info
     rescue Exception => e
       Fabio::Logger::log("Exception thrown: #{e}", :type => :warn)
       raise e
    end
  end

end

class Executors < WorkerStack
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Executor::Ant
      use Executor::Rake
      use Executor::DefaultExecutor
    end
  end

  def call env
    run_env(env, :exec) do |z|
      @stack.call(z)
    end

    @app.call env
  end
end
