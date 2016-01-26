class LocalisationsController < ApplicationController
  before_action :set_localisation, only: [:show, :edit, :update, :destroy]

  # GET /localisations
  # GET /localisations.json
  def index
    @localisations = Localisation.all
  end

  # GET /localisations/1
  # GET /localisations/1.json
  def show
  end

  # GET /localisations/new
  def new
    @localisation = Localisation.new
  end

  # GET /localisations/1/edit
  def edit
  end

  # POST /localisations
  # POST /localisations.json
  def create
    @localisation = Localisation.new(localisation_params)

    respond_to do |format|
      if @localisation.save
        format.html { redirect_to @localisation, notice: 'Localisation was successfully created.' }
        format.json { render :show, status: :created, location: @localisation }
      else
        format.html { render :new }
        format.json { render json: @localisation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /localisations/1
  # PATCH/PUT /localisations/1.json
  def update
    respond_to do |format|
      if @localisation.update(localisation_params)
        format.html { redirect_to @localisation, notice: 'Localisation was successfully updated.' }
        format.json { render :show, status: :ok, location: @localisation }
      else
        format.html { render :edit }
        format.json { render json: @localisation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /localisations/1
  # DELETE /localisations/1.json
  def destroy
    @localisation.destroy
    respond_to do |format|
      format.html { redirect_to localisations_url, notice: 'Localisation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_localisation
      @localisation = Localisation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def localisation_params
      params.require(:localisation).permit(:title, :description, :published)
    end
end
