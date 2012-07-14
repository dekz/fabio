require 'middleware'
require File.join(File.dirname(__FILE__), 'repositories/cvs')
require File.join(File.dirname(__FILE__), 'repositories/git')

class Repositories
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Repository::CVS
      use Repository::Git
    end
  end

  def call env
    puts "--> Repositories"
    @stack.call env if env.member? :repository
    @app.call env
    puts "<-- Repositories"
  end
end
