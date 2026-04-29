# frozen_string_literal: true

require "faraday"
require "json"

class GlpiClient # rubocop:disable Metrics/ClassLength
  API_URL = Rails.application.credentials.glpi_api_url
  API_KEY = Rails.application.credentials.glpi_apikey
  PROXY_URL = Rails.application.credentials.proxy_url
  DEFAULT_PARAMS = [
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
    # "add_keys_names=[]", # Retrieve friendly names. Array containing fkey(s) and/or "id". Optional.
  ].freeze

  attr_reader :connection, :session_token

  def initialize(connection = Faraday.new(API_URL, { ssl: { verify: false }, proxy: PROXY_URL }))
    @connection = if Rails.env.production?
                    connection
                  else
                    Faraday.new { |b| b.adapter(:test, stubs) }
                  end
    @session_token = init_session
  end

  def computer_glpi_id(serial:)
    get_glpi_id_for(Computer::ENDPOINT, serial:)
  end

  def computer(glpi_id:, params: nil)
    equipment(Computer, glpi_id:, params:)
  end

  def network_equipment_glpi_id(serial:)
    get_glpi_id_for(NetworkEquipment::ENDPOINT, serial:)
  end

  def network_equipment(glpi_id:, params: nil)
    equipment(NetworkEquipment, glpi_id:, params:)
  end

  private

  def init_session
    resp = @connection.get("initSession") do |request|
      request.headers["Authorization"] = "user_token #{API_KEY}"
      request.headers["App-Token"] = API_KEY
    end
    JSON.parse(resp.body)["session_token"]
  end

  def equipment(klass, glpi_id:, params: nil)
    return nil if glpi_id.blank?

    resp = get_equipment_for(klass::ENDPOINT, glpi_id:, params:)
    begin
      body = JSON.parse(resp.body)
      return nil if body.blank?
    rescue JSON::ParserError => e
      Rails.logger.warn "Error parsing JSON: #{e}"
      Rails.logger.warn "Response body: #{resp.inspect}"
      raise
    end

    klass.new format_body(body)
  end

  def get_glpi_id_for(endpoint, serial:)
    resp = @connection.get("#{endpoint}?searchText[serial]=#{serial}") do |request|
      request.headers["Session-Token"] = session_token
      request.headers["App-Token"] = API_KEY
    end

    params = JSON.parse(resp.body).first
    if params.present?
      params["id"]
    end
  end

  def get_equipment_for(endpoint, glpi_id:, params:)
    params ||= DEFAULT_PARAMS

    @connection.get("#{endpoint}/#{glpi_id}?#{params.join("&")}") do |request|
      request.headers["Session-Token"] = session_token
      request.headers["App-Token"] = API_KEY
    end
  end

  def format_body(body)
    body.deep_transform_keys(&:underscore)

    attributes = body
    attributes[:hard_drives] = body["_devices"].present? ? body["_devices"]["Item_DeviceHardDrive"] : {}
    attributes[:memories] = body["_devices"].present? ? body["_devices"]["Item_DeviceMemory"] : {}
    processors = body["_devices"].present? ? body["_devices"]["Item_DeviceProcessor"] : {}
    attributes[:processors] = if processors.present?
                                processors.each_value do |proc|
                                  proc["designation"] = get_processor_designation_for(id: proc["deviceprocessors_id"])
                                end
                              else
                                {}
                              end

    attributes
  end

  def get_processor_designation_for(id:)
    return if id.blank?

    resp = @connection.get("DeviceProcessor/#{id}") do |request|
      request.headers["Session-Token"] = session_token
      request.headers["App-Token"] = API_KEY
    end
    processor_params = JSON.parse(resp.body)
    if processor_params.present?
      processor_params["designation"]
    end
  end

  def stubs
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get(%r{^/?Computer(\?.*)?$}) { |_env| [200, {}, Rails.root.join("test/services/computers_results.json").read] }
      stub.get(%r{^/?NetworkEquipment(\?.*)?$}) { |_env| [200, {}, Rails.root.join("test/services/network_equipments_results.json").read] }
      stub.get(%r{Computer/.*}) { |_env| [200, {}, Rails.root.join("test/services/computer_algori.json").read] }
      stub.get(%r{NetworkEquipment/.*}) { |_env| [200, {}, Rails.root.join("test/services/network_equipment_algori.json").read] }
      stub.get(%r{DeviceProcessor/.*}) { |_env| [200, {}, Rails.root.join("test/services/processor.json").read] }
      stub.get("/initSession") { |_env| [200, {}, '{"session_token":"kuji8uh4v77lgghqoj2c0r2848"}'] }
    end
  end

  module Types
    include Dry.Types()
  end

  class Equipment < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :id, Types::Coercible::Integer
    attribute? :serial, Types::Coercible::String
    attribute? :name, Types::Coercible::String
    attribute? :contact, Types::Coercible::String
    attribute? :disks, Types::Coercible::Hash
    attribute? :hard_drives, Types::Coercible::Hash
    attribute? :memories, Types::Coercible::Hash
    attribute? :processors, Types::Coercible::Hash

    def hard_drives_total_capacity
      return 0 if hard_drives.blank?

      hard_drives.sum { |_key, value| value["capacity"] }
    end

    def memories_total_size
      return 0 if memories.blank?

      memories.sum { |_key, value| value["size"] }
    end
  end

  class Computer < Equipment
    ENDPOINT = "Computer"
  end

  class NetworkEquipment < Equipment
    ENDPOINT = "NetworkEquipment"
  end
end
