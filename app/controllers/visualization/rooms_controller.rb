# frozen_string_literal: true

module Visualization
  class RoomsController < ApplicationController
    include RoomsHelper

    before_action :set_room, only: :show
    before_action :set_servers_per_frames, only: :show

    def show
      @sites = Site.joins(:rooms).includes(:rooms => [:bays => [:bay_type]]).order(:position).distinct
      @islet = Islet.find_by(name: params[:islet], room_id: @room.id) if params[:islet].present?

      @air_conditioners = AirConditioner.all

      respond_to do |format|
        format.html
        format.json
        format.txt { send_data Frame.to_txt(@servers_per_frames[@room.id], params[:bg]) }
      end
    end

    private

    def set_room
      @room = Room.friendly.find(params[:id].to_s.downcase)
    end

    def room_params
      params.require(:room).permit(:name, :description, :display_on_home_page, :position, :site_id)
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
  end
end
