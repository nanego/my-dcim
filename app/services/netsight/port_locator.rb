# frozen_string_literal: true

module Netsight
  # DCIM names switches after their Netsight sysName, plus ":SlotN" for stack members
  class PortLocator
    SWITCH_NAME = /\A\s*(?<sys_name>[\w-]+)(?::slot(?<slot>\d+))?/i
    PORTS_PER_SLOT = 1000
    NON_DATA_PORT_TYPES = %w[FAN].freeze

    Result = Data.define(:status, :port, :sys_name, :ip, :if_index, :if_name) do
      def found? = status == :found
    end

    def self.parse_name(name)
      match = SWITCH_NAME.match(name.to_s) or return
      [match[:sys_name], (match[:slot] || 1).to_i]
    end

    # Switch ports are numbered across the data cards in composant order: a 48RJ
    # card holds ports 1 to 48, and the 4FC card after it ports 49 to 52. A card
    # whose first position is set in DCIM starts at that number.
    def self.numbered_ports(server)
      offset = 0
      data_cards = server.cards.includes(card_type: :port_type, composant: [], ports: :connection).select do |card|
        !card.is_power? && NON_DATA_PORT_TYPES.exclude?(card.card_type&.port_type&.name.to_s.upcase)
      end
      data_cards.sort_by { |card| [card.composant&.position.to_i, card.id] }.each_with_object({}) do |card, numbered|
        offset = card.first_position - 1 if card.first_position.to_i.positive?
        card.ports.each { |port| numbered[offset + port.position.to_i] = port }
        offset += card.port_quantity.to_i
      end
    end

    def initialize(client: Client.new)
      @client = client
    end

    def call(port)
      candidates(port).each do |candidate|
        sys_name, slot = self.class.parse_name(candidate.server.name)
        ip = sys_name && @client.device_ip(sys_name) or next
        number = self.class.numbered_ports(candidate.server).key(candidate)

        return Result.new(status: :found, port: candidate, sys_name:, ip:,
                          if_index: (slot * PORTS_PER_SLOT) + number, if_name: "#{slot}:#{number}")
      end

      Result.new(status: :no_switch, port: nil, sys_name: nil, ip: nil, if_index: nil, if_name: nil)
    end

    private

    def candidates(port)
      [port, port.paired_connection&.port].compact.select do |candidate|
        candidate.card.present? && candidate.server.present? && !candidate.is_power?
      end
    end
  end
end
