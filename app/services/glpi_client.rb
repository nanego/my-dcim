# frozen_string_literal: true

require "faraday"
require "json"

class GlpiClient
  API_URL = Rails.application.credentials.glpi_api_url
  API_KEY = Rails.application.credentials.glpi_apikey
  PROXY_URL = Rails.application.credentials.proxy_url

  attr_reader :connection, :session_token

  def initialize(connection = Faraday.new(API_URL, { ssl: { verify: false }, proxy: PROXY_URL }))
    if Rails.env.production?
      @connection = connection
    else
      @connection = Faraday.new { |b| b.adapter(:test, stubs) }
    end
    @session_token = init_session
  end

  def computer(serial:, params: nil)
    glpi_id = get_computer_id_from_glpi(serial: serial)
    if glpi_id.present?
      params ||= [
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
      ]
      resp = @connection.get("Computer/#{glpi_id}?#{params.join("&")}") do |request|
        request.headers["Session-Token"] = session_token
        request.headers["App-Token"] = API_KEY
      end
      begin
        computer_params = JSON.parse(resp.body)
      rescue JSON::ParserError => e
        Rails.logger.warn "Error parsing JSON: #{e}"
        Rails.logger.warn "Response body: #{resp.inspect}"
        raise
      end
      if computer_params.present?
        computer_params.deep_transform_keys(&:underscore)

        attributes = computer_params
        attributes[:hard_drives] = computer_params["_devices"].present? ? computer_params["_devices"]["Item_DeviceHardDrive"] : {}
        attributes[:memories] = computer_params["_devices"].present? ? computer_params["_devices"]["Item_DeviceMemory"] : {}
        processors = computer_params["_devices"].present? ? computer_params["_devices"]["Item_DeviceProcessor"] : {}
        attributes[:processors] = if processors.present?
                                    processors.each_value do |proc|
                                      proc["designation"] = get_processor_designation_from_glpi(id: proc["deviceprocessors_id"])
                                    end
                                  else
                                    {}
                                  end

        Computer.new(attributes)
      end
    end
  end

  def get_processor_designation_from_glpi(id:)
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

  def get_computer_id_from_glpi(serial:)
    serial = "AZERTY" unless Rails.env.production?

    resp = @connection.get("Computer?searchText[serial]=#{serial}") do |request|
      request.headers["Session-Token"] = session_token
      request.headers["App-Token"] = API_KEY
    end
    computer_params = JSON.parse(resp.body).first
    if computer_params.present?
      computer_params["id"]
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
      stub.get("/Computer?searchText%5Bserial%5D=AZERTY") { |_env| [200, {}, Rails.root.join("test/services/computers_results.json").read] }
      stub.get(%r{/Computer/4090?.*}) { |_env| [200, {}, Rails.root.join("test/services/computer_4090_algori.json").read] }
      stub.get(%r{/DeviceProcessor/28?.*}) { |_env| [200, {}, Rails.root.join("test/services/processor_28.json").read] }
      stub.get("/initSession") { |_env| [200, {}, '{"session_token":"kuji8uh4v77lgghqoj2c0r2848"}'] }
    end
  end

  module Types
    include Dry.Types()
  end

  class Computer < Dry::Struct
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
end
