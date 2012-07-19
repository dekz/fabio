require 'middleware'
require File.join(File.dirname(__FILE__), 'executors/exec')
require File.join(File.dirname(__FILE__), 'executors/ant')
require File.join(File.dirname(__FILE__), 'executors/rake')

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
      use Executor::Rake
      use Executor::DefaultExecutor
    end
  end

  def call env
    puts "--> Executors"
    if env[:env].member? :exec
      ae = [env[:env][:exec]] if env[:env][:exec].is_a? Hash
      ae.each do |e|
        @stack.call({ :env => e, :out => env[:out] })
      end
    end
    @app.call env
    puts "<-- Executors"
  end
end
