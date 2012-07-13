require 'middleware'
require File.join(File.dirname(__FILE__), 'commands/ping')
require File.join(File.dirname(__FILE__), 'commands/info')

class Commands
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Ping
      use Info
    end
  end

  def call env
    puts "--> Commands"
    @stack.call env if env.member? :cmd
    @app.call env
    puts "<-- Commands"
  end
end
