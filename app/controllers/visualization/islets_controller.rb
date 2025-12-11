# frozen_string_literal: true

module Visualization
  class IsletsController < BaseController
    include RoomsHelper

    before_action :set_islet, only: %i[print]
    before_action :set_room, only: %i[print]
    before_action :set_servers_per_frames, only: %i[print]

    def print
      respond_to do |format|
        format.html { render "visualization/rooms/print", layout: "pdf" }
        format.pdf do
          render "visualization/rooms/print",
                 ferrum_pdf: {},
                 layout: "pdf",
                 filename: "islet_#{@islet}_#{[params[:view], params[:bg]].compact.join("-")}.pdf",
                 disposition: :inline
        end
      end
    end

    private

    def set_islet
      authorize! @islet = Islet.find(params[:id])
    end

    def set_room
      @room = @islet.room
    end

    def set_servers_per_frames
      frames = Frames::IncludingServersQuery.call(@islet.frames)
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
  end
end
