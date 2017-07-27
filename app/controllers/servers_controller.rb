class ServersController < ApplicationController
  include ServersHelper

  before_action :set_server, only: [:show, :edit, :update, :destroy]

  def index
    unless params[:servers_grid].present?
      params[:servers_grid] = {"column_names"=>["id", "name", "type"]}
    end

    @servers = ServersGrid.new(params[:servers_grid])
    render "servers_grids/index"
  end

  def grid
    @servers = ServersGrid.new(params[:servers_grid])
  end

  def sort
    room = Room.find_by_name(params[:room]) unless params[:room].include?('non ')
    frame = room.frames.where('islets.name = ? AND frames.name = ?', params[:islet], params[:frame]).first
    positions = params[:positions].split(',')
    params[:server].each_with_index do |id, index|
      if positions[index].present?
        server = Server.find_by_id(id)
        new_params = {position: positions[index]}
        new_params.merge!({frame_id: frame.id}) if frame.present?
        updated_values = track_updated_values(server, new_params)
        if server.save && updated_values.present?
          server.create_activity action: 'update', parameters: updated_values, owner: current_user
        end
      end
    end if params[:server].present?
    render nothing: true
  end

  def show
    @agregated_ports_per_server = {}
    @agregated_ports_per_server[@server.id] = get_ports_per_bay_on_a_server(bay_id: @server.frame.bay_id, server: @server) if @server.aggregate_ports?
  end

  def new
    @server = Server.new
  end

  def edit
  end

  def create
    @server = Server.new(server_params)

    respond_to do |format|
      if @server.save
        @server.create_activity action: 'create', owner: current_user
        format.html { redirect_to @server, notice: 'Server was successfully created.' }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      old_values = @server.attributes
      updated_values = track_updated_values(@server, server_params)
      if @server.save
        updated_values.merge!(track_frame_and_position(old_values, @server.attributes)) if updated_values.key?("position") || updated_values.key?("frame_id")
        @server.create_activity action: 'update', parameters: updated_values, owner: current_user
        format.html { redirect_to @server, notice: 'Server was successfully updated.' }
        format.json { render :show, status: :ok, location: @server }
      else
        format.html { render :edit }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_csv

  end

  def import
    new_frame = Server.import(params[:import][:file], Room.find_by_id(params[:import][:room_id]), ServerState.find_by_id(params[:import][:server_state_id]))
    redirect_to frame_path(new_frame), notice: 'Les nouveaux servers ont été ajoutés' # frame_url()
  end

  def destroy
    @server.create_activity action: 'destroy', parameters: @server.attributes, owner: current_user
    @server.destroy
    respond_to do |format|
      format.html { redirect_to servers_grids_path, notice: 'Server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.where('lower(numero) = ?', params[:id].to_s.downcase).first
      @server = Server.friendly.find(params[:id].to_s.downcase) unless @server
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def server_params
      params.require(:server).permit(:server_state_id, :port_color, :comment, :cluster_id, :position, :frame_id, :gestion_id, :fc_futur, :rj45_cm, :category_id, :name, :nb_elts, :architecture_id, :u, :marque_id, :modele_id, :numero, :conso, :critique, :domaine_id, :gestion_id, :fc_total, :fc_utilise, :rj45_total, :rj45_utilise, :rj45_futur, :ipmi_utilise, :ipmi_futur, :rg45_cm, :ipmi_dedie, :frame, :cards_attributes => [:composant_id, :card_type_id, :_destroy, :id, :connections_identifier], :disks_attributes => [:quantity, :disk_type_id, :_destroy, :id], :memory_components_attributes => [:quantity, :memory_type_id, :_destroy, :id])
    end

    def track_frame_and_position(old_values, new_values)
      new_params = {}
      new_params['frame'] = [Frame.find_by_id(old_values['frame_id']).to_s, Frame.find_by_id(new_values['frame_id']).to_s]
      new_params['position'] = [old_values['position'].to_s, new_values['position'].to_s]
      #%W"position frame_id".each do |attribute|
      #  new_params[attribute] = [old_values[attribute].to_s, new_values[attribute]]
      #end
      return new_params
    end

end
