# frozen_string_literal: true

class ConnectionsController < ApplicationController # rubocop:disable Metrics/ClassLength
  def edit # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity
    authorize!

    @from_port = if params[:from_port_id].present? && params[:from_port_id].to_i.positive?
                   Port.find_by_id(params[:from_port_id])
                 else
                   attachable = if params["card_id"]
                                  Card.find(params["card_id"])
                                elsif params["socket_id"]
                                  PowerDistributionUnit::Socket.find(params["socket_id"])
                                end

                   Port.create(position: params["position"],
                               attachable:,
                               vlans: params["vlans"],
                               color: params["color"],
                               cablename: params["cablename"])
                 end

    @frame = @from_port.frame
    @room = @frame.room
    @from_server = @from_port.server
    @from_pdu = @from_port.circuit&.record unless @from_server

    @coupled_frames = @frame.bay.frames
    @possible_destination_servers = []
    @all_servers_per_frame = []
    if @from_port.is_power_input? && @from_server.is_not_a_pdu?
      # @coupled_frames.each { |frame| @possible_destination_servers << [frame.name, frame.pdus.collect { |v| [v.name, v.id] }] }
      # Frame.order(:name).each { |frame| @all_servers_per_frame << [frame.name, frame.pdus.collect { |v| [v.name, v.id] }] }
    else
      @coupled_frames.each { |frame| @possible_destination_servers << [frame.name, frame.servers.collect { |v| [v.name, v.id] }] }
      Frame.order(:name).each { |frame| @all_servers_per_frame << [frame.name, frame.servers.collect { |v| [v.name, v.id] }] }
    end

    # Destination port
    if @from_port.connection.present? && @from_port.connection.cable.present?
      @cable = @from_port.connection.cable
    end

    @to_port = @cable.connections.reject { |conn| conn.port_id.to_i == @from_port.id }.first.try(:port) if @cable.present?

    # Destination server
    @to_server = if @to_port.present?
                   @to_port.server
                 elsif @from_port.is_power_input?
                   nil # @frame.pdus.first
                 else
                   @frame.servers.where("position IS NOT NULL AND modele_id IS NOT NULL").order(:position).first
                 end

    if @to_server
      @to_server.create_missing_ports
      @to_server.reload
    end
  end

  def update
    authorize!

    from_port = Port.find(params[:connection][:from_port_id])
    to_port = Port.find(params[:connection][:to_port_id])

    from_port.connect_to_port(to_port,
                              params[:connection][:cablename],
                              params[:connection][:color],
                              params[:connection][:vlans],
                              params[:connection][:special_case],
                              params[:connection][:comments])

    @from_server = from_port.server
    @from_pdu = from_port.circuit&.record unless @from_server

    @to_server = to_port.server

    respond_to do |format|
      format.html do
        redirect_to connections_edit_path(from_port_id: from_port.id), notice: t(".flashes.updated")
      end
      format.js
    end
  end

  def update_destination_server
    authorize!

    @server = Server.find_by_id(params[:server_id])

    if @server
      @server.create_missing_ports
      @server.reload
    end

    if params[:with_moved_connection]
      @moved_connections = MovedConnection.per_servers([@server])
    end
  end

  def draw
    authorize!

    @server = Server.find_by_id(params[:server_id])
    @connections_through_twin_cards = {}
    @server.cards.each do |card|
      card.ports.each do |port|
        twin_card_ports = []
        if card.twin_card
          twin_card_ports << Port.where(attachable: card.twin_card, position: port.position).first
        end
        if port.paired_connection.present?
          paired_connection_port = port.paired_connection.port
          next if paired_connection_port.attachable.is_a?(PowerDistributionUnit::Socket)

          twin_card_ports << Port.where(attachable: paired_connection_port.card.twin_card, position: paired_connection_port.position).first
        end
        twin_card_ports.compact.uniq.each do |twin_card_port|
          if twin_card_port.present? && twin_card_port.connection.present?
            twin_card_paired_connection = twin_card_port.paired_connection
            if twin_card_paired_connection.present?
              @connections_through_twin_cards[port.id] = { twin_card_port_id: twin_card_port.id,
                                                           twin_card_paired_port_id: twin_card_paired_connection.port_id,
                                                           cable_color: twin_card_port.cable_color,
                                                           cable_name: twin_card_port.cable_name }
            end
          end
        end
      end
    end

    respond_to do |format|
      format.js
    end
  end
end
