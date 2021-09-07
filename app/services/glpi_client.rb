require 'faraday'
require 'json'

class GlpiClient

  API_URL = Rails.application.credentials.glpi_url
  API_KEY = Rails.application.credentials.glpi_apikey
  API_PROXY = Rails.application.credentials.glpi_proxy

  attr_reader :connection

  def initialize(connection = Faraday.new(API_URL, { ssl: { verify: false }, proxy: API_PROXY }))
    if Rails.env.production?
      @connection = connection
    else
      @connection = Faraday.new { |b| b.adapter(:test, stubs) }
    end
  end

  def computer(serial:)
    resp = @connection.get("Computer?searchText[serial]=#{serial}") do |request|
      request.headers["Authorization"] = API_KEY
      request.headers["App-Token"] = API_KEY
    end
    computer_params = JSON.parse(resp.body).first
    computer_params.deep_transform_keys(&:underscore)
    Computer.new(computer_params)
  end

  def stubs
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/Computer?searchText%5Bserial%5D=AZERTY') { |env| [200, {}, File.read(Rails.root.join('test', 'services', 'computer_4090_algori.json'))] }
    end
  end

end

class GlpiClient::Computer
  include Virtus.model

  attribute :id, Integer
  attribute :serial, String
  attribute :name, String
end
