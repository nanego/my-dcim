class ServersController < ApplicationController
  include ServersHelper

  before_action :set_server, only: [:show, :edit, :update, :destroy]

  def index
    unless params[:servers_grid].present?
      params[:servers_grid] = {"column_names"=>["id", "localisation", "rack", "nom", "type"]}
    end

    @servers = ServersGrid.new(params[:servers_grid])
    render "servers_grids/index"
  end

  def grid
    @servers = ServersGrid.new(params[:servers_grid])
  end

  def baies
    @modele_blank_panel_id = Category.find_by_title('Blank Panel').id

    @baies = Baie.includes(:salle, :coupled_baie).joins(:salle).order('salles.title asc, baies.ilot asc, baies.position asc')
    @baies = @baies.joins(:servers).where('servers.cluster_id = ? ', params[:cluster_id]) if params[:cluster_id].present?
    @baies = @baies.joins(:servers).where('servers.gestion_id = ? ', params[:gestion_id]) if params[:gestion_id].present?

    @servers = Server.includes(:baie, :gestion, :modele => :category)
                    .where('baie_id IN (?)', @baies.map(&:id))
                    .order('servers.position desc')

    @servers_par_baies = {}
    @sums = {}
    @baies.each do |baie|
      @servers_par_baies[baie.salle] ||= {}
      @servers_par_baies[baie.salle][baie.ilot] ||= {}
      @servers_par_baies[baie.salle][baie.ilot][baie] ||= []

      # preload sums per baie
      servers = baie.servers.includes(:gestion, :cluster, :modele => :category, :cards => :port_type, :cards_servers => [:composant, :ports])
      @sums.merge!(calculate_ports_sums(baie, servers))
    end
    @servers.each do |server|
      baie = server.baie
      @servers_par_baies[baie.salle][baie.ilot][baie] << server if baie.present?
    end

    respond_to do |format|
      format.html do
        render 'baies.html.erb'
      end
      format.pdf do
        render layout: 'pdf.html',
               template: "servers/baies.pdf.erb",
               show_as_html: params[:debug].present?,
               pdf: 'baie',
               zoom: 0.75
      end
      format.txt { txt = ""; @servers_par_baies.each { |salle, ilots| txt << Baie.to_txt(ilots) }; send_data txt; }
    end

  end

  def sort
    salle = Salle.find_by_title(params[:salle]) unless params[:salle].include?('non ')
    baie = Baie.where(salle_id: salle.id, ilot: params[:ilot], title: params[:baie]).first
    positions = params[:positions].split(',')
    params[:server].each_with_index do |id, index|
      if positions[index].present?
        server = Server.find_by_id(id)
        new_params = {position: positions[index]}
        new_params.merge!({baie_id: baie.id}) if baie.present?
        updated_values = track_updated_values(server, new_params)
        if server.save && updated_values.present?
          server.create_activity action: 'update', parameters: updated_values, owner: current_user
        end
      end
    end if params[:server].present?
    render nothing: true
  end

  def show
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
        updated_values.merge!(track_baie_and_position(old_values, @server.attributes)) if updated_values.key?("position") || updated_values.key?("baie_id")
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
    new_baie = Server.import(params[:import][:file], Salle.find_by_id(params[:import][:salle_id]), ServerState.find_by_id(params[:import][:server_state_id]))
    redirect_to baie_path(new_baie), notice: 'Les nouveaux servers ont été ajoutés' # baie_url()
  end

  def destroy
    @server.create_activity action: 'destroy', parameters: @server.attributes, owner: current_user
    @server.destroy
    respond_to do |format|
      format.html { redirect_to servers_url, notice: 'Server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.friendly.find(params[:id].to_s.downcase)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def server_params
      params.require(:server).permit(:server_state_id, :comment, :cluster_id, :position, :baie_id, :localisation_id, :armoire_id, :gestion_id, :fc_futur, :rj45_cm, :category_id, :nom, :nb_elts, :architecture_id, :u, :marque_id, :modele_id, :numero, :conso, :critique, :domaine_id, :gestion_id, :acte_id, :fc_total, :fc_utilise, :rj45_total, :rj45_utilise, :rj45_futur, :ipmi_utilise, :ipmi_futur, :rg45_cm, :ipmi_dedie, :baie, :cards_servers_attributes => [:composant_id, :card_id, :_destroy, :id])
    end

    def track_baie_and_position(old_values, new_values)
      new_params = {}
      new_params['baie'] = [Baie.find_by_id(old_values['baie_id']).to_s, Baie.find_by_id(new_values['baie_id']).to_s]
      new_params['position'] = [old_values['position'].to_s, new_values['position'].to_s]
      #%W"position baie_id".each do |attribute|
      #  new_params[attribute] = [old_values[attribute].to_s, new_values[attribute]]
      #end
      return new_params
    end

end
