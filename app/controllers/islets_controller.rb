# frozen_string_literal: true

class IsletsController < ApplicationController
  include RoomsHelper

  before_action :set_islet, only: [:show, :edit, :update, :destroy]

  def index
    @islets = Islet.joins(:room).order('rooms.site_id asc, rooms.position asc, islets.name asc')
  end

  def show
    frames = Frames::IncludingServersQuery.call(@islet.frames)
    @room = @islet.room
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

    respond_to do |format|
      format.pdf do
        render layout: 'pdf.html',
               template: "rooms/show.pdf.erb",
               show_as_html: params[:debug].present?,
               pdf: 'frame',
               zoom: 0.75
      end
      format.txt { send_data Frame.to_txt(@servers_per_frames[@room.id], params[:bg]) }
    end
  end

  # GET /islets/new
  def new
    @islet = Islet.new
  end

  # GET /islets/1/edit
  def edit
  end

  # POST /islets
  # POST /islets.json
  def create
    @islet = Islet.new(islet_params)

    respond_to do |format|
      if @islet.save
        format.html { redirect_to islets_url, notice: 'Islet was successfully created.' }
        format.json { render :show, status: :created, location: @islet }
      else
        format.html { render :new }
        format.json { render json: @islet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /islets/1
  # PATCH/PUT /islets/1.json
  def update
    respond_to do |format|
      if @islet.update(islet_params)
        format.html { redirect_to islets_url, notice: 'Islet was successfully updated.' }
        format.json { render :show, status: :ok, location: @islet }
      else
        format.html { render :edit }
        format.json { render json: @islet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /islets/1
  # DELETE /islets/1.json
  def destroy
    if @islet.destroy
      respond_to do |format|
        format.html { redirect_to islets_url, notice: 'Islet a bien été supprimé.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to islets_url, alert: @islet.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_islet
    @islet = Islet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def islet_params
    params.require(:islet).permit(:name, :room_id, :position)
  end
end
