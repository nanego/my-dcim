class MovesController < ApplicationController
  before_action :set_move, only: [:show, :edit, :update, :destroy]
  before_action :load_form_data, only: [:new, :edit]

  # GET /moves
  # GET /moves.json
  def index
    @moves = Move.all
  end

  # GET /moves/1
  # GET /moves/1.json
  def show
  end

  # GET /moves/new
  def new
    @move = Move.new
  end

  # GET /moves/1/edit
  def edit
  end

  # POST /moves
  # POST /moves.json
  def create
    @move = Move.new(move_params)

    respond_to do |format|
      if @move.save
        format.html { redirect_to edit_move_path(@move), notice: 'Move was successfully created.' }
        format.json { render :show, status: :created, location: @move }
      else
        format.html { render :new }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moves/1
  # PATCH/PUT /moves/1.json
  def update
    respond_to do |format|
      if @move.update(move_params)
        format.html { redirect_to edit_move_path(@move), notice: 'Move was successfully updated.' }
        format.json { render :show, status: :ok, location: @move }
      else
        format.html { render :edit }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moves/1
  # DELETE /moves/1.json
  def destroy
    @move.destroy
    respond_to do |format|
      format.html { redirect_to moves_url, notice: 'Move was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_move
      @move = Move.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def move_params
      params.permit(:moveable_type, :moveable_id, :frame_id, :position)
    end

    def load_form_data
      @all_servers_per_frame = []
      Frame.order(:name).each do |frame|
        @all_servers_per_frame << [frame.name, frame.servers.collect {|v| [ v.name, v.id ] }]
      end

      @all_frames_per_room = []
      Room.order(:position).each do |room|
        @all_frames_per_room << [room.name, room.frames.order('frames.name').collect {|v| [ v.name, v.id ] }]
      end
    end
end
