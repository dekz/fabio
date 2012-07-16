require 'middleware'
require File.join(File.dirname(__FILE__), 'executors/exec')
require File.join(File.dirname(__FILE__), 'executors/ant')

module Executor

  def fexec args
   begin
     puts ('> ' << args)
     `#{args}`
    rescue Exception => e
      p e
   end
  end
  module_function :fexec
end
class Executors
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Executor::Ant
      use Executor::DefaultExecutor
    end
  end

  def call env
    puts "--> Executors"
    @stack.call env if env[:env].member? :exec
    @app.call env
    puts "<-- Executors"
  end
end
