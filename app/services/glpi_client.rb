require 'faraday'
require 'json'

class GlpiClient

  API_URL = Rails.application.credentials.glpi_url
  API_KEY = Rails.application.credentials.glpi_apikey

  attr_reader :connection, :session_token

  def initialize(connection = Faraday.new(API_URL, { ssl: { verify: false } }))
    if Rails.env.production?
      @connection = connection
    else
      @connection = Faraday.new { |b| b.adapter(:test, stubs) }
    end
    @session_token = init_session
  end

  def computer(serial:)
    resp = @connection.get("Computer?searchText[serial]=#{serial}") do |request|
      request.headers["Session-Token"] = @session_token
      request.headers["App-Token"] = API_KEY
    end
    computer_params = JSON.parse(resp.body).first
    computer_params.deep_transform_keys(&:underscore)
    Computer.new(computer_params)
  end

  def init_session
    resp = @connection.get("initSession") do |request|
      request.headers["Authorization"] = "user_token #{API_KEY}"
      request.headers["App-Token"] = API_KEY
    end
    JSON.parse(resp.body)["session_token"]
  end

  def stubs
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/Computer?searchText%5Bserial%5D=AZERTY') { |env| [200, {}, File.read(Rails.root.join('test', 'services', 'computer_4090_algori.json'))] }
      stub.get('/initSession') { |env| [200, {}, '{"session_token":"kuji8uh4v77lgghqoj2c0r2848"}'] }
    end
  end

end

class GlpiClient::Computer
  include Virtus.model

  attribute :id, Integer
  attribute :serial, String
  attribute :name, String
end
