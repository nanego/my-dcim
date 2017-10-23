class MovesController < ApplicationController
  before_action :set_move, only: [:show, :edit, :update, :destroy]
  before_action :load_form_data, only: [:new, :edit]

  # GET /moves
  # GET /moves.json
  def index
    @moves = Move.all
    @frames = @moves.map(&:frame).compact.uniq
  end

  # GET /moves/1
  # GET /moves/1.json
  def show
  end

  # GET /moves/new
  def new
    @move = Move.new(moveable_type: 'Server')
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
        load_form_data
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
        load_form_data
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

  def load_server
    @server = Server.includes(:cards => [:card_type => :port_type], :ports => [:connection => :cable] ).find(params[:server_id])
  end

  def load_frame
    @frame = Frame.find(params[:frame_id])
    @view = params[:view]
  end

  def load_connection
    @selected_port = Port.find(params[:port_id])
    @moved_connections = MovedConnection.where(port_from_id: params[:port_id]).or(MovedConnection.where(port_to_id: params[:port_id]))
    # TODO Deal with conflicts if there is more than 1 result
    if @moved_connections.present?
      @moved_connection = @moved_connections.first
      @destination_port = (@moved_connection.ports - [@selected_port]).first
    else
      @moved_connection = MovedConnection.new(port_from_id: params[:port_id])
    end
    get_all_servers_per_frame
  end

  def update_connection
    @moved_connections = MovedConnection.where('port_from_id IN (?) OR port_to_id IN (?)',
                                               [params[:moved_connection][:port_from_id], params[:moved_connection][:port_to_id]],
                                               [params[:moved_connection][:port_from_id], params[:moved_connection][:port_to_id]])
    # TODO Deal with conflicts if there is more than 1 result
    if @moved_connections.present?
      @moved_connection = @moved_connections.first
    else
      @moved_connection = MovedConnection.new
    end
    @moved_connection.update(moved_connection_params)
    @selected_port = @moved_connection.port_from
    @destination_port = @moved_connection.port_to
    get_all_servers_per_frame
  end

  def frame
    @frame = Frame.find(params[:id])
    @moves = Move.where(frame: @frame, moveable_type: 'Server')
    @moved_servers = @moves.map { |move| server = move.moveable; server.position = move.position; server}
    @servers = (@frame.servers | @moved_servers).sort_by { |server| server.position.present? ? server.position : 0}.reverse

    @servers_ports_ids = @servers.map(&:ports).flatten.map(&:id)
    @moved_connections = MovedConnection.where('port_from_id IN (?) OR port_to_id IN (?)', @servers_ports_ids, @servers_ports_ids)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_move
      @move = Move.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def move_params
      params.require(:move).permit(:moveable_type, :moveable_id, :frame_id, :position )
    end
    def moved_connection_params
      params.require(:moved_connection).permit(:port_from_id, :port_to_id, :vlans, :color, :cablename )
    end

    def load_form_data
      get_all_servers_per_frame
      get_all_frames_per_room
    end

  def get_all_frames_per_room
    @all_frames_per_room = []
    Room.order(:position).each do |room|
      @all_frames_per_room << [room.name, room.frames.order('frames.name').collect {|v| [v.name, v.id]}]
    end
  end

  def get_all_servers_per_frame
    @all_servers_per_frame = []
    Frame.order(:name).each do |frame|
      @all_servers_per_frame << [frame.name, frame.servers.collect {|v| [v.name, v.id]}]
    end
  end
end
