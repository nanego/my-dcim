# frozen_string_literal: true

class FramesController < ApplicationController
  include ServersHelper
  include RoomsHelper

  before_action :set_frame, only: :show

  def index
    @filter = ProcessorFilter.new(Frame.includes(bay: { islet: :room }).references(bay: { islet: :room }), params)
    @frames = @filter.results
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @frame = Frame.new
  end

  def edit
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
  end

  def update
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
    respond_to do |format|
      if @frame.update(frame_params)
        format.html { redirect_to @frame, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @frame }
      else
        format.html { render :edit }
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @frame = Frame.new(frame_params)

    respond_to do |format|
      if @frame.save
        format.html { redirect_to @frame, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @frame }
      else
        format.html { render :new }
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  def sort
    params[:frame].each_with_index do |id, index|
      Frame.where(id: id).update_all(position: index + 1) # rubocop:disable Rails/SkipsModelValidations
    end if params[:frame].present?
    head :ok
  end

  def destroy
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
    if @frame.destroy
      respond_to do |format|
        format.html { redirect_to frames_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to frames_url, alert: @frame.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  def network
    # Set frames for this network
    @frame = Frames::IncludingServersQuery.call(Frame).friendly.find(params[:id].to_s.downcase)
    @coupled_frame = @frame.other_frame
    if @coupled_frame.present?
      @network_frame = Frames::IncludingServersQuery.call(Frame).friendly.find(params[:network_frame_id].to_s.downcase)
    else
      @network_frame = @frame
      @frame = Frames::IncludingServersQuery.call(Frame).friendly.find(params[:network_frame_id].to_s.downcase)
      @coupled_frame = @frame.other_frame
    end

    @frames = [@frame, @coupled_frame, @network_frame].reject(&:blank?)
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
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def frame_params
    params.require(:frame).permit(:name, :u, :room, :islet, :position, :switch_slot, :bay_id)
  end
end
