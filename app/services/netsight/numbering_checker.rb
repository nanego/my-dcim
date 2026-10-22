# frozen_string_literal: true

module Netsight
  # PortLocator guesses the Netsight number of a switch port from the card order.
  # A card whose ports agree much better with Netsight once shifted, or whose
  # ports Netsight doesn't know, is probably numbered wrong. Ports agree when
  # they carry the same VLANs or, without polled VLANs, when a port cabled in
  # DCIM is up in Netsight.
  class NumberingChecker
    MAX_SHIFT = 8
    MIN_GAIN = 3

    Finding = Data.define(:status, :first_port, :if_name, :expected_if_name, :evidence, :matches, :shifted_matches) do
      def result_attributes
        { kind: :numbering, status:, port: first_port, if_name:, netsight_peer: expected_if_name,
          dcim_value: "#{matches}/#{evidence}", netsight_value: ("#{shifted_matches}/#{evidence}" if shifted_matches) }
      end
    end

    def initialize(snapshot)
      @snapshot = snapshot
    end

    # numbered_ports: number => port, for one stack member (see PortLocator.numbered_ports)
    def call(slot, numbered_ports)
      numbered_ports.group_by { |_, port| port.card }.filter_map do |_card, pairs|
        evidence = pairs.select { |_, port| evidence?(port) }
        check(slot, pairs.min_by(&:first), evidence) if evidence.any?
      end
    end

    private

    def check(slot, first, evidence)
      matches = (-MAX_SHIFT..MAX_SHIFT).index_with do |shift|
        evidence.count { |number, port| agrees?(netsight_port(slot, number + shift), port) }
      end

      unknown = evidence.count { |number, _| netsight_port(slot, number).nil? }
      return finding(:unknown_ports, slot, first, evidence, matches) if unknown >= MIN_GAIN && unknown * 2 > evidence.size

      shift = matches.keys.max_by { |candidate| [matches[candidate], -candidate.abs] }
      finding(:shifted, slot, first, evidence, matches, shift) if shifted?(evidence.size, matches[0], matches[shift])
    end

    # A real shift at least halves the disagreements: neighbor trunks often carry the same VLANs
    def shifted?(evidence, current, shifted)
      shifted - current >= MIN_GAIN && (evidence - shifted) * 2 <= evidence - current
    end

    def finding(status, slot, (first_number, first_port), evidence, matches, shift = nil)
      Finding.new(status:, first_port:, if_name: "#{slot}:#{first_number}",
                  expected_if_name: ("#{slot}:#{first_number + shift}" if shift),
                  evidence: evidence.size, matches: matches[0], shifted_matches: (matches[shift] if shift))
    end

    def evidence?(port)
      return port.connection.present? unless @snapshot.vlans_collected

      port.vlans.present? && Client::Port.vlan_list?(port.vlans)
    end

    def agrees?(netsight_port, port)
      return false if netsight_port.nil?
      return netsight_port.oper_status == "Up" unless @snapshot.vlans_collected

      netsight_port.matches_dcim?(port.vlans)
    end

    def netsight_port(slot, number)
      @snapshot.ports["#{slot}:#{number}"]
    end
  end
end
