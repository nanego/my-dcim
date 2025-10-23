# frozen_string_literal: true

class IsletsController < ApplicationController
  include RoomsHelper

  before_action :set_islet, only: %i[show edit update destroy print]
  before_action :set_room, only: %i[show print]
  before_action :set_servers_per_frames, only: %i[show print]
  before_action except: %i[index] do
    breadcrumb.add_step(Islet.model_name.human.pluralize, islets_path)
  end

  def index
    authorize! @islets = scoped_islets.joins(room: :site).order("rooms.site_id asc, rooms.position asc, islets.name asc")
    @filter = ProcessorFilter.new(@islets, params)
    @islets = @filter.results
  end

  def show
    respond_to do |format|
      format.html
      format.json
      format.txt { send_data Frame.to_txt(@servers_per_frames[@room.id], params[:bg]) }
    end
  end

  # GET /islets/new
  def new
    authorize! @islet = Islet.new
    @islet.assign_attributes(islet_params) if params[:islet]
  end

  # GET /islets/1/edit
  def edit; end

  # POST /islets
  # POST /islets.json
  def create
    authorize! @islet = Islet.new(islet_params)

    respond_to do |format|
      if @islet.save
        format.html { redirect_to_new_or_to(@islet, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @islet }
      else
        format.html { render :new }
        format.json { render json: @islet.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /islets/1
  # PATCH/PUT /islets/1.json
  def update
    respond_to do |format|
      if @islet.update(islet_params)
        format.html { redirect_to @islet, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @islet }
      else
        format.html { render :edit }
        format.json { render json: @islet.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /islets/1
  # DELETE /islets/1.json
  def destroy
    if @islet.destroy
      respond_to do |format|
        format.html { redirect_to islets_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to islets_url, alert: @islet.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  def print
    render "visualization/rooms/print", layout: "pdf"
  end

  private

  def scoped_islets
    authorized_scope(Islet.all)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_islet
    authorize! @islet = scoped_islets.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def islet_params
    params.expect(islet: %i[name room_id position description cooling_mode access_control])
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
