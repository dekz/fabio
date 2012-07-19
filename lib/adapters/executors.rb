require 'middleware'
require 'popen4'
require File.join(File.dirname(__FILE__), 'worker_stack')
require File.join(File.dirname(__FILE__), 'executors/exec')
require File.join(File.dirname(__FILE__), 'executors/ant')
require File.join(File.dirname(__FILE__), 'executors/rake')

module Executor

  def fexec args
   begin
     status = POpen4.popen4(args) do |pout, perr, pin, pid|
       puts "#{pid}>>#{caller[0]}\n"
       puts ('> ' << args)
       puts "STDOUT:  #{pout.read}"
       puts "STDERR:  #{perr.read}"
     end
     puts "#{status}<<\n"
    rescue Exception => e
      p e
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
