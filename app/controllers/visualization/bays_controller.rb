# frozen_string_literal: true

module Visualization
  class BaysController < ApplicationController
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
      render "visualization/rooms/print", layout: "pdf"
    end

    private

    def set_bay
      @bay = Bay.find(params[:id])
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
