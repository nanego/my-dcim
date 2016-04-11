class CoupleBaiesController < ApplicationController
  before_action :set_couple_baie, only: [:show, :edit, :update, :destroy]

  # GET /couple_baies
  # GET /couple_baies.json
  def index
    @couple_baies = CoupleBaie.all
  end

  # GET /couple_baies/1
  # GET /couple_baies/1.json
  def show
  end

  # GET /couple_baies/new
  def new
    @couple_baie = CoupleBaie.new
  end

  # GET /couple_baies/1/edit
  def edit
  end

  # POST /couple_baies
  # POST /couple_baies.json
  def create
    @couple_baie = CoupleBaie.new(couple_baie_params)

    respond_to do |format|
      if @couple_baie.save
        format.html { redirect_to @couple_baie, notice: 'Couple baie was successfully created.' }
        format.json { render :show, status: :created, location: @couple_baie }
      else
        format.html { render :new }
        format.json { render json: @couple_baie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /couple_baies/1
  # PATCH/PUT /couple_baies/1.json
  def update
    respond_to do |format|
      if @couple_baie.update(couple_baie_params)
        format.html { redirect_to @couple_baie, notice: 'Couple baie was successfully updated.' }
        format.json { render :show, status: :ok, location: @couple_baie }
      else
        format.html { render :edit }
        format.json { render json: @couple_baie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /couple_baies/1
  # DELETE /couple_baies/1.json
  def destroy
    @couple_baie.destroy
    respond_to do |format|
      format.html { redirect_to couple_baies_url, notice: 'Couple baie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_couple_baie
      @couple_baie = CoupleBaie.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def couple_baie_params
      params.require(:couple_baie).permit(:baie_one_id, :baie_two_id)
    end
end
