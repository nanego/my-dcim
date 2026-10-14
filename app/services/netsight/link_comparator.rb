# frozen_string_literal: true

module Netsight
  # Checks an inter-switch link seen by Netsight against the DCIM cabling, through
  # patch panels and their twin cards. Each link is checked once, from either end.
  class LinkComparator
    def initialize(client:, switches:, numbered_ports:)
      @client = client
      @switches = switches
      @numbered_ports = numbered_ports
      @checked_links = Set.new
    end

    # Attributes of the link result, or nil when there is nothing to check
    def call(ip, port, link)
      ends = [[ip, link.if_name], [link.peer_ip, link.peer_if_name.to_s]].sort
      return if port.nil? || !@checked_links.add?(ends)

      trace = PortPathTracer.new.call(port)
      { status: status(trace, peer_port(link.peer_ip, link.peer_if_name)), server: port.server, port:,
        if_name: link.if_name, dcim_path: trace.label,
        netsight_peer: "#{@client.sys_name_for(link.peer_ip) || link.peer_ip} #{link.peer_if_name}" }
    end

    private

    def status(trace, expected_port)
      if trace.status == :not_cabled then :not_cabled_in_dcim
      elsif trace.reached? && trace.end_port == expected_port then :matches
      elsif trace.status == :broken || trace.ends_on_patch_panel? then :broken_path
      else :differs
      end
    end

    def peer_port(ip, if_name)
      slot, number = if_name.to_s.split(":").map(&:to_i)
      member = @switches[ip].to_a.find { |match| match.slot == slot }
      @numbered_ports[member.server][number] if member
    end
  end
end
