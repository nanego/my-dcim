class BaysController < ApplicationController
  before_action :set_bay, only: [:show, :edit, :update, :destroy]

  # GET /bays
  # GET /bays.json
  def index
    @bays = Bay.all
  end

  # GET /bays/1
  # GET /bays/1.json
  def show
  end

  # GET /bays/new
  def new
    @bay = Bay.new
  end

  # GET /bays/1/edit
  def edit
  end

  # POST /bays
  # POST /bays.json
  def create
    @bay = Bay.new(bay_params)

    respond_to do |format|
      if @bay.save
        format.html { redirect_to @bay, notice: 'Bay was successfully created.' }
        format.json { render :show, status: :created, location: @bay }
      else
        format.html { render :new }
        format.json { render json: @bay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bays/1
  # PATCH/PUT /bays/1.json
  def update
    respond_to do |format|
      if @bay.update(bay_params)
        format.html { redirect_to bays_path, notice: 'La baie a été mise à jour.' }
        format.json { render :show, status: :ok, location: @bay }
      else
        format.html { render :edit }
        format.json { render json: @bay.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bays/1
  # DELETE /bays/1.json
  def destroy
    @bay.destroy
    respond_to do |format|
      format.html { redirect_to bays_url, notice: 'Bay was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bay
      @bay = Bay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bay_params
      params.require(:bay).permit(:name, :lane, :position, :bay_type_id, :islet_id)
    end
end
