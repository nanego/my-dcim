# frozen_string_literal: true

module Visualization
  class FramesController < BaseController
    before_action :set_frame, only: %i[show print]
    before_action :set_room, only: %i[show print]

    def show
      respond_to do |format|
        format.html
        format.js
        format.txt { send_data @frame.to_txt(params[:bg]) }
      end
    end

    def print
      @view_side = params[:view].presence || "front"
      @settings = { min_height: @view_side == "back" ? 20 : 27 }

      respond_to do |format|
        format.html { render layout: "pdf" }
        format.pdf { render ferrum_pdf: {}, layout: "pdf", filename: "frame_#{@frame}.pdf", disposition: :inline }
      end
    end

    def network
      # Set frames for this network
      authorize! @frame = Frames::IncludingServersQuery.call(Frame).friendly.find(params[:id].to_s.downcase)
      @coupled_frame = @frame.other_frame
      if @coupled_frame.present?
        @network_frame = Frames::IncludingServersQuery.call(Frame).friendly.find(params[:network_frame_id].to_s.downcase)
      else
        @network_frame = @frame
        @frame = Frames::IncludingServersQuery.call(Frame).friendly.find(params[:network_frame_id].to_s.downcase)
        @coupled_frame = @frame.other_frame
      end

      @frames = [@frame, @coupled_frame, @network_frame].compact_blank
      @servers_per_frames = {}

      @frames.each do |frame|
        islet = t(".title")
        @servers_per_frames[islet] ||= {}
        @servers_per_frames[islet][0] ||= {}
        @servers_per_frames[islet][0][frame.bay] ||= {}
        @servers_per_frames[islet][0][frame.bay][frame] ||= []
        frame.servers.each do |s|
          @servers_per_frames[islet][0][frame.bay][frame] << s
        end
      end

      respond_to do |format|
        format.html
        format.txt { send_data Frame.to_txt(@servers_per_frames, params[:bg]) }
      end
    end

    private

    def set_frame
      authorize! @frame = Frame.includes(
        bay: [islet: :room],
        servers: [
          :gestion, :cluster,
          { modele: %i[category composants],
            cards: [
              :composant,
              { ports: [connection: [cable: :connections]],
                card_type: :port_type },
            ] },
        ],
      )
        .friendly
        .find(params[:id].to_s.downcase)
    end

    def set_room
      @room = @frame.room
    end
  end
end
