require 'middleware'
require File.join(File.dirname(__FILE__), 'repositories/cvs')

class Repositories
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use CVS
    end
  end

  def call env
    puts "--> Repositories"
    @stack.call env if env.member? :repository
    @app.call env
    puts "<-- Repositories"
  end
end
