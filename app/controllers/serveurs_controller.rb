class ServeursController < ApplicationController
  include ServeursHelper

  before_action :set_serveur, only: [:show, :edit, :update, :destroy]

  def index
    unless params[:serveurs_grid].present?
      params[:serveurs_grid] = {"column_names"=>["id", "localisation", "rack", "nom", "type"]}
    end

    @serveurs = ServeursGrid.new(params[:serveurs_grid])
    render "serveurs_grids/index"
  end

  def grid
    @serveurs = ServeursGrid.new(params[:serveurs_grid])
  end

  def baies
    @modele_blank_panel_id = Category.find_by_title('Blank Panel').id

    @baies = Baie.includes(:salle, :coupled_baie).joins(:salle).order('salles.title asc, baies.ilot asc, baies.position asc')
    @baies = @baies.joins(:serveurs).where('serveurs.cluster_id = ? ', params[:cluster_id]) if params[:cluster_id].present?
    @baies = @baies.joins(:serveurs).where('serveurs.gestion_id = ? ', params[:gestion_id]) if params[:gestion_id].present?

    @serveurs = Serveur.includes(:baie, :gestion, :modele => :category)
                    .where('baie_id IN (?)', @baies.map(&:id))
                    .order('serveurs.position desc')

    @serveurs_par_baies = {}
    @sums = {}
    @baies.each do |baie|
      @serveurs_par_baies[baie.salle] ||= {}
      @serveurs_par_baies[baie.salle][baie.ilot] ||= {}
      @serveurs_par_baies[baie.salle][baie.ilot][baie] ||= []

      # preload sums per baie
      serveurs = baie.serveurs.includes(:gestion, :cluster, :modele => :category, :cards => :port_type, :cards_serveurs => [:composant, :ports])
      @sums.merge!(calculate_ports_sums(baie, serveurs))
    end
    @serveurs.each do |server|
      baie = server.baie
      @serveurs_par_baies[baie.salle][baie.ilot][baie] << server if baie.present?
    end

    respond_to do |format|
      format.html do
        render 'baies.html.erb'
      end
      format.pdf do
        render layout: 'pdf.html',
               template: "serveurs/baies.pdf.erb",
               show_as_html: params[:debug].present?,
               pdf: 'baie',
               zoom: 0.75
      end
      format.txt { txt = ""; @serveurs_par_baies.each { |salle, ilots| txt << Baie.to_txt(ilots) }; send_data txt; }
    end

  end

  def sort
    salle = Salle.find_by_title(params[:salle]) unless params[:salle].include?('non ')
    baie = Baie.where(salle_id: salle.id, ilot: params[:ilot], title: params[:baie]).first
    positions = params[:positions].split(',')
    params[:serveur].each_with_index do |id, index|
      if positions[index].present?
        serveur = Serveur.find_by_id(id)
        new_params = {position: positions[index]}
        new_params.merge!({baie_id: baie.id}) if baie.present?
        updated_values = track_updated_values(serveur, new_params)
        if serveur.save && updated_values.present?
          serveur.create_activity action: 'update', parameters: updated_values, owner: current_user
        end
      end
    end if params[:serveur].present?
    render nothing: true
  end

  def show
  end

  def new
    @serveur = Serveur.new
  end

  def edit
  end

  def create
    @serveur = Serveur.new(serveur_params)

    respond_to do |format|
      if @serveur.save
        @serveur.create_activity action: 'create', owner: current_user
        format.html { redirect_to @serveur, notice: 'Serveur was successfully created.' }
        format.json { render :show, status: :created, location: @serveur }
      else
        format.html { render :new }
        format.json { render json: @serveur.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      old_values = @serveur.attributes
      updated_values = track_updated_values(@serveur, serveur_params)
      if @serveur.save
        updated_values.merge!(track_baie_and_position(old_values, @serveur.attributes)) if updated_values.key?("position") || updated_values.key?("baie_id")
        @serveur.create_activity action: 'update', parameters: updated_values, owner: current_user
        format.html { redirect_to @serveur, notice: 'Serveur was successfully updated.' }
        format.json { render :show, status: :ok, location: @serveur }
      else
        format.html { render :edit }
        format.json { render json: @serveur.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_csv

  end

  def import
    new_baie = Serveur.import(params[:import][:file], Salle.find_by_id(params[:import][:salle_id]), ServerState.find_by_id(params[:import][:server_state_id]))
    redirect_to baie_path(new_baie), notice: 'Les nouveaux serveurs ont été ajoutés' # baie_url()
  end

  def destroy
    @serveur.create_activity action: 'destroy', parameters: @serveur.attributes, owner: current_user
    @serveur.destroy
    respond_to do |format|
      format.html { redirect_to serveurs_url, notice: 'Serveur was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_serveur
      @serveur = Serveur.friendly.find(params[:id].to_s.downcase)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def serveur_params
      params.require(:serveur).permit(:server_state_id, :comment, :cluster_id, :position, :baie_id, :localisation_id, :armoire_id, :gestion_id, :fc_futur, :rj45_cm, :category_id, :nom, :nb_elts, :architecture_id, :u, :marque_id, :modele_id, :numero, :conso, :critique, :domaine_id, :gestion_id, :acte_id, :fc_total, :fc_utilise, :rj45_total, :rj45_utilise, :rj45_futur, :ipmi_utilise, :ipmi_futur, :rg45_cm, :ipmi_dedie, :baie, :cards_serveurs_attributes => [:composant_id, :card_id, :_destroy, :id])
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
