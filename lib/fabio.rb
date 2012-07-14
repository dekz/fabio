require 'middleware'
require File.join(File.expand_path(File.dirname(__FILE__)), 'adapters/commands')
require File.join(File.expand_path(File.dirname(__FILE__)), 'adapters/executors')
require File.join(File.expand_path(File.dirname(__FILE__)), 'adapters/repositories')
require File.join(File.expand_path(File.dirname(__FILE__)), 'adapters/reporters')

class Fabio
  def initialize
  end

  def call(env)
    stack = Middleware::Builder.new do
      use Commands
      use Repositories
      use Executors
      use Reporters
    end
    stack.call env
  end
end
