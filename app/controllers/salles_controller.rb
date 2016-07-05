class SallesController < ApplicationController
  before_action :set_salle, only: [:show, :edit, :update, :destroy, :ilot]

  # GET /salles
  # GET /salles.json
  def index
    @salles = Salle.all
  end

  def show
    @serveurs_par_baies = {}
    @salle.baies.includes(:coupled_baie, :inverse_coupled_baie).order('ilot asc, baies.position asc').each do |baie|
      baie.serveurs.includes(:gestion, :cluster, :modele => :category).each do |s|
        ilot = baie.ilot
        @serveurs_par_baies[ilot] ||= {}
        @serveurs_par_baies[ilot][baie] ||= []
        @serveurs_par_baies[ilot][baie] << s
      end
    end

    respond_to do |format|
      format.html do
        render 'salles/show'
      end
      format.pdf do
        render layout: 'pdf.html',
               template: "salles/show.pdf.erb",
               show_as_html: params[:debug].present?,
               pdf: 'baie',
               zoom: 0.75
      end
      format.txt { send_data Baie.to_txt(@serveurs_par_baies) }
    end
  end

  def ilot
    ilot = params[:ilot]
    @serveurs_par_baies = {}
    @salle.baies.includes(:serveurs).where('baies.ilot = ?', ilot).order('ilot asc, baies.position asc').each do |baie|
      baie.serveurs.includes(:gestion, :modele => :category).each do |s|
        @serveurs_par_baies[baie.ilot] ||= {}
        @serveurs_par_baies[baie.ilot][baie] ||= []
        @serveurs_par_baies[baie.ilot][baie] << s
      end
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
               zoom: 0.75
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
      @salle = Salle.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def salle_params
      params.require(:salle).permit(:title, :description, :published)
    end
end
