class SallesController < ApplicationController
  before_action :set_salle, only: [:show, :edit, :update, :destroy]

  # GET /salles
  # GET /salles.json
  def index
    @salles = Salle.all
  end

  def show
    @serveurs_par_baies ||= {}

    @salle.serveurs.includes(:baie, :gestion, :modele => :category).joins(:baie).order('baies.ilot ASC, baies.position ASC, serveurs.position desc, serveurs.id desc').each do |s|
      ilot = (s.baie.try(:ilot).present? ? s.baie.ilot.to_s : "non précisé")
      baie = (s.baie.title.present? ? s.baie.title.to_s : "non précisée")
      @serveurs_par_baies[ilot] ||= {}
      @serveurs_par_baies[ilot][baie] ||= []
      @serveurs_par_baies[ilot][baie] << s
    end

    respond_to do |format|
      format.html do
        render 'salles/show'
      end
      #format.pdf do
      #  render layout: 'pdf.html',
      #         template: "salles/show.pdf.erb",
      #         show_as_html: params[:debug].present?,
      #         pdf: 'baie',
      #         zoom: 0.8
      #end
      format.txt { send_data Baie.to_txt(@serveurs_par_baies) }
    end
  end

  def ilot
    @baie = Baie.find_by_id(params[:id])
    @ilot = @baie.ilot
    @salle = @baie.salle
    @serveurs_par_baies ||= {}

    Serveur.includes(:gestion, :baie => :salle, :modele => :category)
        .joins(:baie)
        .where("baies.ilot = ?", @ilot)
        .order('baies.position ASC, serveurs.position desc').each do |s|
      ilot = (s.baie.try(:ilot).present? ? s.baie.ilot.to_s : "non précisé")
      baie = (s.baie.title.present? ? s.baie.title.to_s : "non précisée")
      @serveurs_par_baies[ilot] ||= {}
      @serveurs_par_baies[ilot][baie] ||= []
      @serveurs_par_baies[ilot][baie] << s
    end

    respond_to do |format|
      format.html do
        render 'salles/show.html.erb'
      end
      format.pdf do
        render layout: 'pdf.html',
               template: "salles/show.pdf.erb",
               show_as_html: params[:debug].present?,
               pdf: 'baie',
               zoom: 0.8
      end
      format.txt { send_data Baie.to_txt(@serveurs_par_baies) }
    end
  end

  # GET /salles/new
  def new
    @salle = Salle.new
  end

  # GET /salles/1/edit
  def edit
  end

  # POST /salles
  # POST /salles.json
  def create
    @salle = Salle.new(salle_params)

    respond_to do |format|
      if @salle.save
        format.html { redirect_to @salle, notice: 'Salle was successfully created.' }
        format.json { render :show, status: :created, location: @salle }
      else
        format.html { render :new }
        format.json { render json: @salle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /salles/1
  # PATCH/PUT /salles/1.json
  def update
    respond_to do |format|
      if @salle.update(salle_params)
        format.html { redirect_to @salle, notice: 'Salle was successfully updated.' }
        format.json { render :show, status: :ok, location: @salle }
      else
        format.html { render :edit }
        format.json { render json: @salle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /salles/1
  # DELETE /salles/1.json
  def destroy
    @salle.destroy
    respond_to do |format|
      format.html { redirect_to salles_url, notice: 'Salle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_salle
      @salle = Salle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def salle_params
      params.require(:salle).permit(:title, :description, :published)
    end
end
