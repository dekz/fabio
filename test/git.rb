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
    :operation => :pull, #optional
    :working_dir => './fabio', # optional
    :branch => 'master', #optional
    #:out_dir => 'command-builder', # when using clone
  },
  :environments => [
    {
      :type => 'bundler',
      :args => 'install',
      :working_dir => './fabio',
    },
    {
      :type => 'rvm',
      :use => 'ruby-1.9.3-p194'
    },
  ],
  :exec => [
    {
      :type => 'rake',
      :rakefile => 'Rakefile',
      :working_dir => './fabio',
      :target => 'empty',
      :rvm_use => 'jruby-1.6.7',
      :env_args => "TEST_PATH='a'"
    },
#    {
#      :type => 'ant',
#      :buildfile => 'zz.xml',
#      :working_dir => './fabio',
#      :target => 'test',
#      #:java_home => 'java',
#      #:ant_home => '/usr/bin/ant',
#      #:args => ''
#      :opts => '-XX:ParallelGCThreads=2'
#      
#    }
  ],
}

fabio = Fabio::Worker.new
fabio.call env
