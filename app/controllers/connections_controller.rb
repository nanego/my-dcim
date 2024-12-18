# frozen_string_literal: true

class ConnectionsController < ApplicationController
  def index
    @connections = Connection.includes(:port, :card, :server, :card_type, :port_type, cable: :connections)
                                                  .order(created_at: :desc)
    @filter = ProcessorFilter.new(@connections, params)

    @pagy, @connections = pagy(@filter.results)
  end

  def edit
    if params[:from_port_id].present? && params[:from_port_id].to_i > 0
      @from_port = Port.find_by_id(params[:from_port_id])
    else
      @from_port = Port.create(position: params['position'],
                               card_id: params['card_id'],
                               vlans: params['vlans'],
                               color: params['color'],
                               cablename: params['cablename'])
    end

    @frame = @from_port.server.frame
    @room = @frame.room
    @from_server = @from_port.server

    @coupled_frames = @frame.bay.frames
    @possible_destination_servers = []
    @all_servers_per_frame = []
    if @from_port.is_power_input? && @from_server.is_not_a_pdu?
      @coupled_frames.each { |frame| @possible_destination_servers << [frame.name, frame.pdus.collect { |v| [v.name, v.id] }] }
      Frame.order(:name).each { |frame| @all_servers_per_frame << [frame.name, frame.pdus.collect { |v| [v.name, v.id] }] }
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
    if @from_port.is_power_input?
      @to_server = @to_port.present? ? @to_port.server : @frame.pdus.first
    else
      @to_server = @to_port.present? ? @to_port.server : @frame.servers.where.not(position: nil, modele_id: nil).order(:position).first
    end
    if @to_server
      @to_server.create_missing_ports
      @to_server.reload
    end
  end

  def update
    from_port = Port.find(params[:connection][:from_port_id])
    to_port = Port.find(params[:connection][:to_port_id])

    from_port.connect_to_port(to_port,
                              params[:connection][:cablename],
                              params[:connection][:color],
                              params[:connection][:vlans],
                              params[:connection][:special_case],
                              params[:connection][:comments])

    @from_server = from_port.server
    @to_server = to_port.server

    respond_to do |format|
      format.html do
        redirect_to connections_edit_path(from_port_id: from_port.id), notice: t(".flashes.updated")
      end
      format.js
    end
  end

  def update_destination_server
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
    @server = Server.find_by_id(params[:server_id])
    @connections_through_twin_cards = {}
    @server.cards.each do |card|
      twin_card_id = card.try(:twin_card_id)
      card.ports.each do |port|
        twin_card_ports = []
        if twin_card_id.present?
          twin_card_ports << Port.where(card_id: twin_card_id, position: port.position).first
        end
        if port.paired_connection.present?
          paired_connection_port = port.paired_connection.port
          twin_card_id_through_connection = paired_connection_port.card.try(:twin_card_id)
          twin_card_ports << Port.where(card_id: twin_card_id_through_connection, position: paired_connection_port.position).first
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
