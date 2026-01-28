# frozen_string_literal: true

module Visualization
  class BaysController < BaseController
    include RoomsHelper

    before_action :set_bay, only: %i[show print]
    before_action :set_servers_per_frames, only: %i[show print]

    def show
      respond_to do |format|
        format.html
        format.js
        format.txt { send_data Frame.to_txt(@servers_per_frames[@bay.islet.room_id], params[:bg]) }
      end
    end

    def print
      respond_to do |format|
        format.html { render layout: "pdf" }
        format.pdf do
          render ferrum_pdf: {},
                 layout: "pdf",
                 filename: "bay_#{@bay.id}_#{[params[:view], params[:bg]].compact.join("-")}.pdf",
                 disposition: :inline
        end
      end
    end

    private

    def set_bay
      authorize! @bay = Bay.includes(
        :frames,
        islet: :room,
        materials: [
          :gestion, :cluster,
          { modele: %i[category composants],
            cards: [
              :composant,
              { ports: [connection: [cable: :connections]],
                card_type: [:port_type] },
            ] },
        ],
      )
        .find(params[:id])
    end

    def set_servers_per_frames
      @servers_per_frames = {}
      sort_order = frames_sort_order(params[:view], @bay.lane)

      Frames::IncludingServersQuery.call(@bay.frames, "frames.position #{sort_order}").each do |frame|
        room = @bay.islet.room_id
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
  end
end
