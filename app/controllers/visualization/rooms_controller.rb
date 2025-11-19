# frozen_string_literal: true

module Visualization
  class RoomsController < BaseController
    include RoomsHelper

    before_action :set_room, only: %i[show print]
    before_action :set_servers_per_frames, only: %i[show print]
    before_action :set_scoped_sites, only: %i[index show]

    def index
      authorize! @sites

      return unless params[:cluster_id].present? || params[:gestion_id].present? || params[:modele_id].present?

      @frames = Frame
        .preload(servers: [
                   :gestion,
                   :cluster,
                   { modele: :category, card_types: :port_type, cards: [:composant, { ports: [connection: :cable] }] },
                 ])
        .includes(bay: [:frames, { islet: :room }])
        .order("rooms.position asc, islets.name asc, bays.position asc, frames.position asc")
      @current_filters = []
      if params[:cluster_id].present?
        @frames = @frames.joins(:materials).where("servers.cluster_id = ? ", params[:cluster_id])
        @filtered_servers = Server.where("servers.cluster_id = ? ", params[:cluster_id])
        @current_filters << "Cluster #{Cluster.find_by(id: params[:cluster_id])} "
      elsif params[:gestion_id].present?
        @frames = @frames.joins(:materials).where("servers.gestion_id = ? ", params[:gestion_id])
        @filtered_servers = Server.where("servers.gestion_id = ? ", params[:gestion_id])
        @current_filters << "Gestionnaire #{Gestion.find_by(id: params[:gestion_id])} "
      elsif params[:modele_id].present?
        @frames = @frames.joins(:materials).where("servers.modele_id = ? ", params[:modele_id])
        @filtered_servers = Server.where("servers.modele_id = ? ", params[:modele_id])
        @current_filters << "Modèle #{Modele.find_by(id: params[:modele_id])} "
      end

      render :filtered_index
    end

    def show
      authorize! @islet = Islet.find_by(name: params[:islet], room_id: @room.id) if params[:islet].present?

      @air_conditioners = AirConditioner.all

      respond_to do |format|
        format.html
        format.txt { send_data Frame.to_txt(@servers_per_frames[@room.id], params[:bg]) }
      end
    end

    def print
      render layout: "pdf"
    end

    private

    def set_room
      authorize! @room = Room.friendly.find(params[:id].to_s.downcase)
    end

    def set_servers_per_frames
      frames = Frames::IncludingServersQuery.call
      @servers_per_frames = {}

      sorted_frames_per_islet(frames, params[:view]).each do |frame|
        room = frame.bay.islet.room_id
        islet = frame.bay.islet.name
        @servers_per_frames[room] ||= {}
        @servers_per_frames[room][islet] ||= {}
        @servers_per_frames[room][islet][frame.bay.lane] ||= {}
        @servers_per_frames[room][islet][frame.bay.lane][frame.bay] ||= {}
        @servers_per_frames[room][islet][frame.bay.lane][frame.bay][frame] ||= []
        frame.servers.each do |s|
          @servers_per_frames[room][islet][frame.bay.lane][frame.bay][frame] << s
        end
      end
    end

    def set_scoped_sites
      @sites = authorized_scope(Site.all)
        .joins(:rooms)
        .includes(rooms: [bays: [:bay_type]])
        .order(:position)
        .distinct
    end
  end
end
