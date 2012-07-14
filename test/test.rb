require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib/fabio')

env = {
  :version => 0.1,
  :repository => {
    :type =>  'cvs',
    :path => 'master',
  },
  :exec => 'rake',
  :cmd => :ping
}

fabio = Fabio.new
fabio.call env
