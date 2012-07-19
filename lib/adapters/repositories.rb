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

    if env[:env].member? :repository
      z = { :global => env[:env], :out => env[:out] }
      ae = [env[:env][:repository]] if env[:env][:repository].is_a? Hash
      ae.each do |e|
        z[:env] = e
        @stack.call(z)
      end
    end

    @app.call env
    puts "<-- Repositories"
  end
end
