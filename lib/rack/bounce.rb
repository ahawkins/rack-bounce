require "rack/bounce/version"

module Rack
  class Bounce
    DEFAULT_BOUNCER = lambda do |request|
      checks = [
        lambda { |req| ; req.user_agent =~ /masscan/ }
      ]

      checks.any? do |check|
        check.call request
      end
    end

    def initialize(app, &bouncer)
      @app = app
      @bouncer = bouncer || DEFAULT_BOUNCER
    end

    def call(env)
      if bounce?(env)
        [403, { }, [ ]]
      else
        @app.call env
      end
    end

    def bounce?(env)
      request = ::Rack::Request.new env
      @bouncer.call request
    end
  end
end
