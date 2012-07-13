require 'middleware'
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'adapters/commands')
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'adapters/executors')
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'adapters/repositories')
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'adapters/reporters')

class Trace
  def initialize(app, value)
    @app   = app
    @value = value
  end

  def call(env)
    puts "--> #{@value}"
    puts "I should deal with this" if env == @value
    @app.call(env)
    puts "<-- #{@value}"
  end
end

stack = Middleware::Builder.new do
  use Trace, "First"
  use Commands
  use Repositories
  use Executors
  use Reporters
  use Trace, "Last"
end

env = {
  :version => 0.1,
  :repository => {
    :type =>  'cvs',
    :path => 'master',
  },
  :exec => 'rake',
  :cmd => :ping
}

stack.call(env)
