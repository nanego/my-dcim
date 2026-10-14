# frozen_string_literal: true

# Follows the cabling from a port to the equipment at the other end, through
# patch panels: a patch panel card and its twin card join their ports by position
class PortPathTracer
  MAX_HOPS = 8

  Result = Data.define(:status, :end_port, :hops) do
    def reached? = status == :reached

    # A path ending on a patch panel lacks its twin card in DCIM
    def ends_on_patch_panel?
      end_port&.attachable_type == "Card" && Card.on_patch_panels.exists?(id: end_port.attachable_id)
    end

    def label
      hops.map { |hop| "#{hop.server&.name} #{hop.card&.card_type&.name}:#{hop.position}" }.join(" › ")
    end
  end

  def call(port)
    hops = []
    visited = Set[port.id]

    MAX_HOPS.times do
      peer = port.paired_connection&.port or return result(hops.empty? ? :not_cabled : :broken, hops)
      hops << peer
      twin_card = peer.card&.twin_card or return Result.new(status: :reached, end_port: peer, hops:)

      port = twin_card.ports.find { |twin_port| twin_port.position == peer.position }
      return result(:broken, hops) if port.nil? || !visited.add?(port.id)

      hops << port
    end

    result(:broken, hops)
  end

  private

  def result(status, hops)
    Result.new(status:, end_port: nil, hops:)
  end
end
