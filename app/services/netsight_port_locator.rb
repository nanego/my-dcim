# frozen_string_literal: true

# DCIM names switches after their Netsight sysName, plus ":SlotN" for stack members
class NetsightPortLocator
  SWITCH_NAME = /\A\s*(?<sys_name>[\w-]+)(?::slot(?<slot>\d+))?/i
  PORTS_PER_SLOT = 1000

  Result = Data.define(:status, :port, :sys_name, :ip, :if_index) do
    def found? = status == :found
  end

  def initialize(client: NetsightClient.new)
    @client = client
  end

  def call(port)
    candidates(port).each do |candidate|
      match = SWITCH_NAME.match(candidate.server.name.to_s) or next
      ip = @client.device_ip(match[:sys_name]) or next

      # Uplink card positions don't match the switch port numbers
      status = @client.demo? || access_card?(candidate.card) ? :found : :unsupported_card
      if_index = ((match[:slot] || 1).to_i * PORTS_PER_SLOT) + candidate.position.to_i

      return Result.new(status:, port: candidate, sys_name: match[:sys_name], ip:, if_index:)
    end

    Result.new(status: :no_switch, port: nil, sys_name: nil, ip: nil, if_index: nil)
  end

  private

  def candidates(port)
    [port, port.paired_connection&.port].compact.select do |candidate|
      candidate.card.present? && candidate.server.present? && !candidate.is_power?
    end
  end

  def access_card?(card)
    card.server.cards.includes(:card_type).reject(&:is_power?).max_by { |c| c.port_quantity.to_i } == card
  end
end
