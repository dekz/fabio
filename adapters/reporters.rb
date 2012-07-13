require 'middleware'
require File.join(File.dirname(__FILE__), 'reporters/reporter')

class Reporters
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Reporter
    end
  end

  def call env
    puts "--> Reporter"
    @stack.call env if env.member? :report
    @app.call env
    puts "<-- Reporter"
  end
end
