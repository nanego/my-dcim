class DomainesController < ApplicationController
  before_action :set_domaine, only: [:show, :edit, :update, :destroy]

  # GET /domaines
  # GET /domaines.json
  def index
    @domaines = Domaine.all
  end

  # GET /domaines/1
  # GET /domaines/1.json
  def show
  end

  # GET /domaines/new
  def new
    @domaine = Domaine.new
  end

  # GET /domaines/1/edit
  def edit
  end

  # POST /domaines
  # POST /domaines.json
  def create
    @domaine = Domaine.new(domaine_params)

    respond_to do |format|
      if @domaine.save
        format.html { redirect_to @domaine, notice: 'Domaine was successfully created.' }
        format.json { render :show, status: :created, location: @domaine }
      else
        format.html { render :new }
        format.json { render json: @domaine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /domaines/1
  # PATCH/PUT /domaines/1.json
  def update
    respond_to do |format|
      if @domaine.update(domaine_params)
        format.html { redirect_to @domaine, notice: 'Domaine was successfully updated.' }
        format.json { render :show, status: :ok, location: @domaine }
      else
        format.html { render :edit }
        format.json { render json: @domaine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /domaines/1
  # DELETE /domaines/1.json
  def destroy
    @domaine.destroy
    respond_to do |format|
      format.html { redirect_to domaines_url, notice: 'Domaine a bien été supprimé.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_domaine
      @domaine = Domaine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def domaine_params
      params.require(:domaine).permit(:name, :description, :published)
    end
end
