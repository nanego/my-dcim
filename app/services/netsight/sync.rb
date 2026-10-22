# frozen_string_literal: true

module Netsight
  # Compares every DCIM switch known to Netsight with the live data: identity
  # (serial number, name), port numbering, port VLANs and inter-switch links. Results are stored
  # for review, nothing is written to DCIM.
  class Sync
    def initialize(request, client: Client.new)
      @request = request
      @client = client
      @skipped_servers = []
      @numbered_ports = Hash.new { |cache, server| cache[server] = PortLocator.numbered_ports(server) }
    end

    def call
      report_identity_issues
      report_switches_missing_from_netsight

      switches.each_with_index do |(ip, members), index|
        sync_switch(ip, members)
      rescue Client::Error, Faraday::Error => e
        report_unreachable(ip, members, e)
      ensure
        @request.update(progress: (index + 1) * 100 / switches.size)
      end

      replace_previous_results
    end

    private

    def candidate_servers
      @candidate_servers ||= Server.no_pdus.includes(:modele).to_a
    end

    def matches
      @matches ||= begin
        matcher = SwitchMatcher.new(@client)
        candidate_servers.filter_map { |server| matcher.call(server) }
      end
    end

    def link_comparator
      @link_comparator ||= LinkComparator.new(client: @client, switches:, numbered_ports: @numbered_ports)
    end

    # Matched DCIM servers grouped by Netsight device (one server per stack member)
    def switches
      @switches ||= matches.group_by(&:ip)
    end

    def report_identity_issues
      matches.select(&:issue).each do |match|
        record(kind: :switch, status: match.issue, server: match.server, dcim_value: match.server.numero,
               netsight_value: match.netsight_serial, netsight_peer: device_label(match.ip, match.slot))
      end
    end

    # Servers of the same models as the matched switches, but unknown to Netsight
    def report_switches_missing_from_netsight
      matched = matches.map(&:server)
      switch_modele_ids = matched.map(&:modele_id).uniq

      (candidate_servers - matched).select { |server| switch_modele_ids.include?(server.modele_id) }.each do |server|
        record(kind: :switch, status: :not_in_netsight, server:, dcim_value: server.numero)
      end
    end

    # A switch Netsight could not answer for keeps its previous port and link results
    def replace_previous_results
      previous = NetsightSyncResult.where.not(external_app_request: @request)
      previous.where.not(server: @skipped_servers).or(previous.kind_switch).delete_all
    end

    def report_unreachable(ip, members, error)
      Rails.logger.error "Netsight synchronization of #{ip} failed: #{error.message}"

      members.each do |match|
        @skipped_servers << match.server
        record(kind: :switch, status: :netsight_unreachable, server: match.server,
               netsight_value: error.message.truncate(255), netsight_peer: device_label(ip, match.slot))
      end
    end

    def sync_switch(ip, members)
      snapshot = @client.device_snapshot(ip:) or return
      dcim_ports = dcim_ports_by_if_name(members)
      check_numbering(snapshot, members)

      # Without polled VLANs, Netsight only has its own, unreliable, configuration
      dcim_ports.each { |if_name, port| compare_vlans(port, if_name, snapshot.ports[if_name]) } if snapshot.vlans_collected
      snapshot.links.each do |link|
        attributes = link_comparator.call(ip, dcim_ports[link.if_name], link) and record(kind: :link, **attributes)
      end
    end

    def check_numbering(snapshot, members)
      checker = NumberingChecker.new(snapshot)
      members.each do |match|
        findings = checker.call(match.slot, @numbered_ports[match.server])
        findings.each { |finding| record(server: match.server, **finding.result_attributes) }
      end
    end

    def dcim_ports_by_if_name(members)
      members.each_with_object({}) do |match, ports|
        @numbered_ports[match.server].each { |number, port| ports["#{match.slot}:#{number}"] = port }
      end
    end

    # Only ports in use in DCIM: cabled, or with VLANs filled in
    def compare_vlans(port, if_name, netsight_port)
      return if port.connection.nil? && port.vlans.blank?
      return record_vlans(port, if_name, :unknown_port) if netsight_port.nil?
      return if netsight_port.matches_dcim?(port.vlans)

      status = if netsight_port.no_vlan? then :no_netsight_vlans
               elsif !Client::Port.vlan_list?(port.vlans) then :free_text
               elsif netsight_port.default_vlan_only? then :default_vlan_only
               else :differs
               end
      record_vlans(port, if_name, status, netsight_value: netsight_port.dcim_vlans)
    end

    def record_vlans(port, if_name, status, netsight_value: nil)
      record(kind: :vlan, status:, server: port.server, port:, if_name:, dcim_value: port.vlans, netsight_value:)
    end

    def device_label(ip, slot)
      "#{@client.sys_name_for(ip) || ip} slot #{slot}"
    end

    def record(**attributes)
      NetsightSyncResult.create!(external_app_request: @request, **attributes)
    end
  end
end
