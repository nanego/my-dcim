# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class DynamicFullHostTest < ActiveSupport::TestCase
  def make_env(path = '/auth/test', props = {})
    {
      'REQUEST_METHOD' => 'GET',
      'PATH_INFO' => path,
      'rack.session' => {},
      'rack.input' => StringIO.new('test=true')
    }.merge(props)
  end

  def setup
    app = lambda { |_env| [404, {}, ['Awesome']] }
    @strategy = ExampleStrategy.new(app, {})
  end

  def test_full_host_without_specific_origin
    @strategy.call!(make_env('/whatever', 'rack.url_scheme' => 'http', 'SERVER_NAME' => 'facebook.lame',
                                          'QUERY_STRING' => 'code=asofibasf|asoidnasd', 'SCRIPT_NAME' => '', 'SERVER_PORT' => 80))
    assert @strategy.full_host, 'http://example.com'
  end

  def test_full_host_with_url_origin
    env = { "omniauth.origin" => 'http://example.com/sub_uri/origin' }
    @strategy.call(make_env('/auth/test/callback', env))
    assert @strategy.full_host, 'http://example.com'
  end
end

class ExampleStrategy
  include OmniAuth::Strategy
  attr_reader :last_env

  option :name, 'test'

  def call(env)
    options[:dup] ? super : call!(env)
  end

  def initialize(*args, &block)
    super
    @fail = nil
  end
end
