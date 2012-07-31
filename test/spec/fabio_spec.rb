$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../../lib'))

require 'fabio'
require 'adapters/executors'
require 'middleware'

describe 'Executors' do
  it 'returns "hi" in stdout when echoed' do
    class Zz
      include Executor
      def test(*args)
        fexec *args
      end
    end
    Zz.new.test 'echo "hi"' do |pout, perr| 
      pout.read.chomp.should == 'hi'
    end

    resp = Zz.new.test 'echo "hi"'
    resp[:stdout].chomp.should == 'hi'
  end

  it 'should work as plain middleware' do
    require 'adapters/commands'
    stack = Middleware::Builder.new do
      use Commands
    end

    stack.call('a')
    stack.call('a')
    stack.call({ :cmd => :info })
    stack.call({ :env =>  { :cmd => :info } })
    stack.call({ :env =>  { :cmd => [ :type => :info ] } })
    stack.call({ :env =>  { :cmd => [ :type => 'info' ] } })
    stack.call({ :cmd => :ping })
    stack.call({ :env =>  { :cmd => :ping } })
    stack.call({ :env =>  { :cmd => [ :type => :ping ] } })
  end

  it 'should do info command' do
    env = { :cmd => [ :type => 'info' ] }
    fabio = Fabio::Worker.new
    f = fabio.call env
    out = f[:out].read
    out.should == 'Info!'

    env = { :cmd => [ :type => 'info' ] }
    f = fabio.call env
    out = f[:out].read
    out.should == 'Info!'

    env = { :cmd => 'info' }
    f = fabio.call env
    out = f[:out].read
    out.should == 'Info!'
  end

end
