require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib/fabio')

env = {
  :version => 0.1,
  :repository => {
    :type =>  'cvs',
    :path => 'master',
  },
  :exec => 'ant',
  :cmd => :ping
}

fabio = Fabio::Worker.new
fabio.call env
