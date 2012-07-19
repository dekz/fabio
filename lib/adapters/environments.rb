require 'middleware'
require File.join(File.dirname(__FILE__), 'environments/bundler')

class Environments
  def initialize(app)
    @app = app
    @stack = Middleware::Builder.new do
      use Environment::Bundler
    end
  end

  def call env
    puts "--> Environments"
    if env[:env].member? :environments
      ae = [env[:env][:environments]] if env[:env][:environments].is_a? Hash
      ae.each do |e|
        p e
        @stack.call({ :env => e, :out => env[:out] })
      end
    end
    @app.call env
    puts "<-- Environments"
  end
end
