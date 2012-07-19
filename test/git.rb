require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib/fabio')

env = {
  :version => 0.1,
  :cmd => [
    { :type => 'info' },
    { :type => 'ping' }
  ],
  :repository => {
    :type =>  'git',
    :path => 'https://github.com/dekz/fabio.git',
    :out_dir => 'fabio'
  },
  :environments => {
    :type => 'bundler',
    :args => 'install',
    :working_dir => './fabio',
  },
  :exec => [
    {
      :type => 'rake',
      :working_dir => './fabio',
      :target => 'test' 
    },
    {
      :type => 'ant',
      :working_dir => './fabio',
      :target => 'test' 
    }
  ],
}

fabio = Fabio::Worker.new
fabio.call env
