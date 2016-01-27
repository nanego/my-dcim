class ModelesController < ApplicationController
  before_action :set_modele, only: [:show, :edit, :update, :destroy]

  # GET /modeles
  # GET /modeles.json
  def index
    @modeles = Modele.all
  end

  # GET /modeles/1
  # GET /modeles/1.json
  def show
  end

  # GET /modeles/new
  def new
    @modele = Modele.new
  end

  # GET /modeles/1/edit
  def edit
  end

  # POST /modeles
  # POST /modeles.json
  def create
    @modele = Modele.new(modele_params)

    respond_to do |format|
      if @modele.save
        format.html { redirect_to @modele, notice: 'Modele was successfully created.' }
        format.json { render :show, status: :created, location: @modele }
      else
        format.html { render :new }
        format.json { render json: @modele.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modeles/1
  # PATCH/PUT /modeles/1.json
  def update
    respond_to do |format|
      if @modele.update(modele_params)
        format.html { redirect_to @modele, notice: 'Modele was successfully updated.' }
        format.json { render :show, status: :ok, location: @modele }
      else
        format.html { render :edit }
        format.json { render json: @modele.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modeles/1
  # DELETE /modeles/1.json
  def destroy
    @modele.destroy
    respond_to do |format|
      format.html { redirect_to modeles_url, notice: 'Modele was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modele
      @modele = Modele.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modele_params
      params.require(:modele).permit(:title, :description, :published)
    end
end
