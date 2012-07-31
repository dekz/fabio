module Reporter
  class StdOutReporter
    include Fabio::Logger
    def initialize(app)
      @app = app
    end

    def call(env)
      log :report_before, :type => :debug
      @app.call env
      pos_before = env[:out].pos
      env[:out].rewind
      puts env[:out].read
      env[:out].pos = pos_before
      log :report_after, :type => :debug
    end
  end
end
