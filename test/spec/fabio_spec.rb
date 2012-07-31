$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../../lib'))

require 'fabio'
require 'adapters/executors'
require 'middleware'

describe 'Executors' do
  it 'returns "hi" in stdout when echoed' do
    Executor::fexec 'echo "hi"' do |pout, perr| 
      pout.read.chomp.should == 'hi'
    end

    resp = Executor::fexec 'echo "hi"'
    resp[:stdout].chomp.should == 'hi'
  end

  it 'should work as plain middleware' do
    require 'adapters/commands'
    stack = Middleware::Builder.new do
      use Commands
    end

    stack.call('a')
  end

end
