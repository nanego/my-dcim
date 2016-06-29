class ServeursController < ApplicationController
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

    @baies = Baie.includes(:salle).joins(:salle).order('salles.title asc, ilot asc, baies.position asc')
    @baies = @baies.joins(:serveurs).where('serveurs.cluster_id = ? ', params[:cluster_id]) if params[:cluster_id].present?
    @baies = @baies.joins(:serveurs).where('serveurs.gestion_id = ? ', params[:gestion_id]) if params[:gestion_id].present?

    @serveurs = Serveur.includes(:baie, :gestion, :modele => :category)
                    .where('baie_id IN (?)', @baies.map(&:id))
                    .order('serveurs.position desc')

    @serveurs_par_baies = {}
    @baies.each do |baie|
      @serveurs_par_baies[baie.salle] ||= {}
      @serveurs_par_baies[baie.salle][baie.ilot] ||= {}
      @serveurs_par_baies[baie.salle][baie.ilot][baie] ||= []
    end
    @serveurs.each do |server|
      baie = server.baie
      @serveurs_par_baies[baie.salle][baie.ilot][baie] << server if baie
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

  def baie
    @ilot = params[:ilot]
    @salle = Salle.find_by_title(params[:salle])
    @baie = Baie.where(salle_id: @salle.id, ilot: params[:ilot], title: params[:baie]).first
    @serveurs = @baie.serveurs
    @sum_u = @serveurs.to_a.sum { |s| s.modele.try(:u) || 0 }
    @sum_elements = @serveurs.to_a.sum { |s| s.modele.try(:nb_elts) || 0 }
    @sum_rj45_futur = @serveurs.to_a.sum { |s| s.try(:rj45_futur) || 0 }
    @sum_fc_futur = @serveurs.to_a.sum { |s| s.try(:fc_futur) || 0 }
  end

  def sort
    salle = Salle.find_by_title(params[:salle]) unless params[:salle].include?('non ')
    baie = Baie.where(salle_id: salle.id, ilot: params[:ilot], title: params[:baie]).first
    positions = params[:positions].split(',')
    params[:serveur].each_with_index do |id, index|
      serveur = Serveur.find_by_id(id)
      new_params = {position: positions[index]}
      new_params.merge!({baie_id: baie.id}) if baie.present?
      updated_values = track_updated_values(serveur, new_params)
      if serveur.save && updated_values.present?
        serveur.create_activity action: 'update', parameters: updated_values, owner: current_user
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
      updated_values = track_updated_values(@serveur, serveur_params)
      if @serveur.save
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
    new_baie = Serveur.import(params[:file])
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
      @serveur = Serveur.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def serveur_params
      params.require(:serveur).permit(:cluster_id, :position, :baie_id, :localisation_id, :armoire_id, :gestion_id, :fc_futur, :rj45_cm, :category_id, :nom, :nb_elts, :architecture_id, :u, :marque_id, :modele_id, :numero, :conso, :critique, :domaine_id, :gestion_id, :acte_id, :fc_total, :fc_utilise, :rj45_total, :rj45_utilise, :rj45_futur, :ipmi_utilise, :ipmi_futur, :rg45_cm, :ipmi_dedie, :baie, :cards_serveurs_attributes => [:composant_id, :card_id, :_destroy, :id])
    end
end
