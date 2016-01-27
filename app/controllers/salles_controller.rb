class SallesController < ApplicationController
  before_action :set_salle, only: [:show, :edit, :update, :destroy]

  # GET /salles
  # GET /salles.json
  def index
    @salles = Salle.all
  end

  # GET /salles/1
  # GET /salles/1.json
  def show
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
