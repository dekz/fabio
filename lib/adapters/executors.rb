require 'middleware'
require 'popen4'
require File.join(File.dirname(__FILE__), 'worker_stack')
require File.join(File.dirname(__FILE__), 'executors/exec')
require File.join(File.dirname(__FILE__), 'executors/ant')
require File.join(File.dirname(__FILE__), 'executors/rake')

module Executor

  class ExecutionError < Exception
  end

  def fexec args
   begin
     err = nil
     stdout = nil
     who_called_me = caller[0]
     puts ('> ' << args)
     status = POpen4.popen4(args) do |pout, perr, pin, pid|
       puts "#{pid} >> #{who_called_me}\n"
       err = perr.read
       stdout = pout.read
     end

     puts "STDOUT:  #{stdout}" unless stdout.empty?
     puts "STDERR:  #{err}" unless stderr.empty?

     if !status.success?
       err_info = {
         :pid => status.pid,
         :stderr => err,
         :cmd => args,
         :stdout => stdout,
         :status => status.exitstatus
       }
       raise ExecutionError, err_info
     end
    rescue Exception => e
      p e
      raise e
   end
  end
  module_function :fexec

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
