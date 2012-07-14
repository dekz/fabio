require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib/fabio')

env = {
  :version => 0.1,
  :repository => {
    :type =>  'git',
    :path => 'git@gist.github.com:698c2216b314fb2c4420.git',
  },
}

fabio = Fabio.new
fabio.call env
