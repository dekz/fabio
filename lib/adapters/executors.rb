require 'middleware'
require File.join(File.dirname(__FILE__), 'worker_stack')
require File.join(File.dirname(__FILE__), 'executors/exec')
require File.join(File.dirname(__FILE__), 'executors/ant')
require File.join(File.dirname(__FILE__), 'executors/rake')

module Executor

  def fexec args
   begin
     puts ">>#{caller[0]}\n"
     puts ('> ' << args)
     o = `#{args}`
     puts  o
     puts "<<\n"
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
