require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib/fabio')

env = {
  :version => 0.1,
  :cmd => [
    { :type => 'info' },
    { :type => 'ping' }
  ],
  :repository => {
    :type =>  'cvs',
    :options => '-d:pserver:anonymous@cvs.savannah.nongnu.org:/web/testytest',
    :path => 'testytest',
    :working_dir => './temp', # optional
  },
  :exec => [
    {
      :type => 'ant',
      :working_dir => './temp/testytest',
      :args => '-version',
    }
  ],
  :report => true,
}

begin
fabio = Fabio::Worker.new
fabio.call env
rescue Exception => e
  puts e
  puts e.backtrace
end
