# frozen_string_literal: true

require "faraday"
require "json"
require "cgi"

class GlpiClient # rubocop:disable Metrics/ClassLength
  APP_URL = GlpiApiConfig.url
  API_URL = GlpiApiConfig.api_url
  API_KEY = GlpiApiConfig.apikey
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

  def initialize
    @connection = if Rails.env.production? || GlpiApiConfig.local_server
                    Faraday.new(API_URL, { ssl: { verify: false }, proxy: PROXY_URL }) do |f|
                      f.response :raise_error
                    end
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

    body = get_glpi_item_for(klass::ENDPOINT, id: glpi_id, params:)
    return nil if body.blank?

    klass.new format_body(body)
  rescue Faraday::ResourceNotFound
    nil
  rescue JSON::ParserError => e
    Rails.logger.warn "Error parsing JSON: #{e}"
    Rails.logger.warn "Response body: #{resp.inspect}"
    raise
  end

  def get_glpi_id_for(endpoint, serial:)
    resp = @connection.get("#{endpoint}?searchText[serial]=#{CGI.escape(serial.to_s)}") do |request|
      request.headers["Session-Token"] = session_token
      request.headers["App-Token"] = API_KEY
    end

    params = JSON.parse(resp.body).first
    if params.present?
      params["id"]
    end
  end

  def with_error_handling
    proc do
      yield
    rescue Faraday::ResourceNotFound
      nil
    rescue JSON::ParserError => e
      Rails.logger.warn "Error parsing JSON: #{e}"
      raise
    end
  end

  def format_body(body)
    body.deep_transform_keys(&:underscore)

    attributes = body
    attributes[:_lazy] = {}

    attributes[:hard_drives] = body["_devices"].present? ? body["_devices"]["Item_DeviceHardDrive"] : {}
    attributes[:memories] = body["_devices"].present? ? body["_devices"]["Item_DeviceMemory"] : {}
    attributes[:state] = body["_keys_names"].present? ? body["_keys_names"]["states_id"] : ""

    group_ids = body["groups_id_tech"].is_a?(Array) ? body["groups_id_tech"] : []
    attributes[:_lazy][:groups] = with_error_handling { group_ids.map { |id| get_group_for(id:) }.to_sentence }

    contract_ids = body["_contracts"].is_a?(Array) ? body["_contracts"].pluck("contracts_id") : []
    attributes[:_lazy][:contracts] = with_error_handling { contract_ids.map { |id| get_contract_for(id:) } }

    processors = body["_devices"].present? ? body["_devices"]["Item_DeviceProcessor"] : {}
    attributes[:_lazy][:processors] = with_error_handling do
      next {} if processors.blank?

      processors.tap do |processors|
        processors.each_value do |proc|
          proc["designation"] = get_processor_designation_for(id: proc["deviceprocessors_id"])
        end
      end
    end

    attributes
  end

  def get_processor_designation_for(id:)
    get_glpi_item_for("DeviceProcessor", id:)["designation"]
  end

  def get_group_for(id:)
    get_glpi_item_for("Group", id:)["name"]
  end

  def get_contract_for(id:)
    params = ["get_hateoas=false", "add_keys_names[]=contracttypes_id"]
    raw = get_glpi_item_for("Contract", id:, params:)

    { name: raw["name"], type: raw["_keys_names"]["contracttypes_id"] }
  end

  def get_glpi_item_for(endpoint, id:, params: nil)
    return if id.blank?

    params ||= DEFAULT_PARAMS
    resp = @connection.get("#{endpoint}/#{id}?#{params.join("&")}") do |request|
      request.headers["Session-Token"] = session_token
      request.headers["App-Token"] = API_KEY
    end

    JSON.parse(resp.body)
  end

  def stubs
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get(%r{^/?Computer(\?.*)?$}) { |_env| [200, {}, Rails.root.join("test/services/computers_results.json").read] }
      stub.get(%r{^/?NetworkEquipment(\?.*)?$}) { |_env| [200, {}, Rails.root.join("test/services/network_equipments_results.json").read] }
      stub.get(%r{Computer/.*}) { |_env| [200, {}, Rails.root.join("test/services/computer_algori.json").read] }
      stub.get(%r{NetworkEquipment/.*}) { |_env| [200, {}, Rails.root.join("test/services/network_equipment_algori.json").read] }
      stub.get(%r{DeviceProcessor/.*}) { |_env| [200, {}, Rails.root.join("test/services/processor.json").read] }
      stub.get(%r{Group/.*}) { |_env| [200, {}, Rails.root.join("test/services/group.json").read] }
      stub.get(%r{Contract/.*}) { |_env| [200, {}, Rails.root.join("test/services/contracts_results.json").read] }
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
    attribute? :state, Types::Coercible::String
    attribute? :disks, Types::Coercible::Hash
    attribute? :hard_drives, Types::Coercible::Hash
    attribute? :memories, Types::Coercible::Hash

    attribute? :_lazy, Types::Coercible::Hash

    def hard_drives_total_capacity
      return 0 if hard_drives.blank?

      hard_drives.sum { |_key, value| value["capacity"] }
    end

    def memories_total_size
      return 0 if memories.blank?

      memories.sum { |_key, value| value["size"] }
    end

    def groups
      @groups ||= _lazy[:groups].call
    end

    def contracts
      @contracts ||= _lazy[:contracts].call
    end

    def processors
      @processors ||= _lazy[:processors].call
    end
  end

  class Computer < Equipment
    ENDPOINT = "Computer"

    def url
      "#{APP_URL}/front/computer.form.php?id=#{id}"
    end
  end

  class NetworkEquipment < Equipment
    ENDPOINT = "NetworkEquipment"

    def url
      "#{APP_URL}/front/network_equipment.form.php?id=#{id}"
    end
  end
end
