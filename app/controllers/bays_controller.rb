# frozen_string_literal: true

class BaysController < ApplicationController
  include RoomsHelper

  before_action :set_bay, only: [:edit, :update, :destroy, :show, :print]
  before_action :set_servers_per_frames, only: %i[print] # TODO: Remove me when print on visualization

  def index
    @filter = ProcessorFilter.new(Bay.joins(:room, :islet).order('rooms.position, islets.name, bays.lane, bays.position'), params)
    @bays = @filter.results
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @bay = Bay.new
  end

  def edit; end

  def create
    @bay = Bay.new(bay_params)

    respond_to do |format|
      if @bay.save
        format.html { redirect_to bays_path, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @bay }
      else
        format.html { render :new }
        format.json { render json: @bay.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @bay.update(bay_params)
        format.html { redirect_to bays_path, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @bay }
      else
        format.html { render :edit }
        format.json { render json: @bay.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @bay.destroy
      respond_to do |format|
        format.html { redirect_to bays_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to bays_url, alert: @bay.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  def print
    render "rooms/print", layout: "pdf"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def bay_params
    params.require(:bay).permit(:name, :lane, :position, :bay_type_id, :islet_id)
  end
end
