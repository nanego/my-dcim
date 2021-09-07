require 'faraday'
require 'json'

class GlpiClient

  API_URL = Rails.application.credentials.glpi_url

  attr_reader :connection

  def initialize(connection = Faraday.new(API_URL, { ssl: { verify: false } }))
    if Rails.env.production?
      @connection = connection
    else
      @connection = Faraday.new { |b| b.adapter(:test, stubs) }
    end
  end

  def computer(serial:)
    resp = @connection.get("Computer?searchText[serial]=#{serial}")
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
