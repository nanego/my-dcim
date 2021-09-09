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
    glpi_id = get_glpi_id(serial: serial)
    if glpi_id.present?
      params = [
        "expand_dropdowns=false", # (default: false) Show dropdown name instead of id. Optional.
        "get_hateoas=true", # (default: true) Show relations of the item in a links attribute. Optional.
        "get_sha1=false", # (default: false) Get a sha1 signature instead of the full answer. Optional.
        "with_devices=true", # Only for [Computer, NetworkEquipment, Peripheral, Phone, Printer], retrieve the associated components. Optional.
        "with_disks=true", # Only for Computer, retrieve the associated file-systems. Optional.
        "with_softwares=true", # Only for Computer, retrieve the associated software's installations. Optional.
        "with_connections=true", # Only for Computer, retrieve the associated direct connections (like peripherals and printers) .Optional.
        "with_networkports=true", # Retrieve all network's connections and advanced network's informations. Optional.
        "with_infocoms=true", # Retrieve financial and administrative informations. Optional.
        "with_contracts=true", # Retrieve associated contracts. Optional.
        "with_documents=true", # Retrieve associated external documents. Optional.
        "with_tickets=false", # Retrieve associated ITIL tickets. Optional.
        "with_problems=false", # Retrieve associated ITIL problems. Optional.
        "with_changes=false", # Retrieve associated ITIL changes. Optional.
        "with_notes=true", # Retrieve Notes. Optional.
        "with_logs=false", # Retrieve historical. Optional.
        "add_keys_names=true", # Retrieve friendly names. Array containing fkey(s) and/or "id". Optional.
      ]
      resp = @connection.get("Computer/#{glpi_id}?#{params.join('&')}") do |request|
        request.headers["Session-Token"] = session_token
        request.headers["App-Token"] = API_KEY
      end
      computer_params = JSON.parse(resp.body)
      if computer_params.present?
        computer_params.deep_transform_keys(&:underscore)
        computer = Computer.new(computer_params)
        computer.hard_drives = computer_params['_devices']['Item_DeviceHardDrive']
        computer.memories = computer_params['_devices']['Item_DeviceMemory']
      end
    end
    return computer
  end

  def get_glpi_id(serial:)
    resp = @connection.get("Computer?searchText[serial]=#{serial}") do |request|
      request.headers["Session-Token"] = session_token
      request.headers["App-Token"] = API_KEY
    end
    computer_params = JSON.parse(resp.body).first
    if computer_params.present?
      return computer_params["id"]
    end
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
      stub.get('/Computer?searchText%5Bserial%5D=AZERTY') { |env| [200, {}, File.read(Rails.root.join('test', 'services', 'computers_results.json'))] }
      stub.get(/\/Computer\/4090?.*/) { |env| [200, {}, File.read(Rails.root.join('test', 'services', 'computer_4090_algori.json'))] }
      stub.get('/initSession') { |env| [200, {}, '{"session_token":"kuji8uh4v77lgghqoj2c0r2848"}'] }
    end
  end

end

class GlpiClient::Computer
  include Virtus.model

  attribute :id, Integer
  attribute :serial, String
  attribute :name, String
  attribute :disks, Hash
  attribute :hard_drives, Hash
  attribute :memories, Hash

  def hard_drives_total_capacity
    hard_drives.sum { |key, value| value['capacity'] }
  end

  def memories_total_size
    memories.sum { |key, value| value['size'] }
  end

end
