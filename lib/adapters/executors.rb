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
    exec_in_dir dir do
      run_cmd args
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

  def run_cmd cmd
   begin
     err = nil
     stdout = nil
     who_called_me = caller[3]
     puts ('> ' << cmd)
     status = POpen4.popen4(cmd) do |pout, perr, pin, pid|
       puts "#{pid} >> #{who_called_me}\n"
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
