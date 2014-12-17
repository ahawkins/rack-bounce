require_relative 'test_helper'

class AcceptanceTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  class HelloWorld
    def call(env)
      [ 200, { 'Content-Type' => 'text/plain' }, [ 'Hi' ] ]
    end
  end

  attr_reader :app

  def build
    builder = Rack::Builder.new
    builder.use Rack::Lint
    yield builder if block_given?
    builder.use Rack::Lint

    builder.run HelloWorld.new
    builder.to_app
  end

  def test_bouncers_masscan_by_deafult
    @app = build do |rack|
      rack.use Rack::Bounce
    end

    get '/', { } , 'HTTP_USER_AGENT' => 'masscan/1.0 (https://github.com/robertdavidgraham/masscan)'
    assert_equal 403, last_response.status
  end

  def test_can_supply_a_custom_bouncer
    @app = build do |rack|
      rack.use Rack::Bounce do |req|
        true
      end
    end

    get '/'
    assert_equal 403, last_response.status
  end

  def test_does_not_apply_default_when_block_given
    @app = build do |rack|
      rack.use Rack::Bounce do |req|
        false
      end
    end

    get '/', { } , 'HTTP_USER_AGENT' => 'masscan/1.0 (https://github.com/robertdavidgraham/masscan)'
    assert last_response.ok?
  end

  def test_allows_other_requests
    @app = build

    get '/foo'
    assert last_response.ok?
  end
end
