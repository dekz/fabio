require 'middleware'
require 'popen4'
require File.join(File.dirname(__FILE__), 'worker_stack')
require File.join(File.dirname(__FILE__), 'executors/exec')
require File.join(File.dirname(__FILE__), 'executors/ant')
require File.join(File.dirname(__FILE__), 'executors/rake')

module Executor

  class ExecutionError < Exception
  end

  def fexec args, dir=nil
    who_called_me = caller[0]
    exec_in_dir dir do

      return block_cmd(args) do |o,e,i,d|
        puts "#{d} >> #{who_called_me}\n"
        yield o,e,i,d
      end if block_given?

      default_cmd args
    end
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
      puts ("#{Dir.pwd}> " << cmd)
      status = block_cmd(cmd) do |pout, perr, pin, pid|
        err = perr.read
        stdout = pout.read
      end

      puts "STDOUT:  #{stdout}" unless stdout.empty?
      puts "STDERR:  #{err}" unless err.empty?

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

      return info
     rescue Exception => e
       p e
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
    puts "--> Executors"

    run_env(env, :exec) do |z|
      @stack.call(z)
    end

    @app.call env
    puts "<-- Executors"
  end
end
