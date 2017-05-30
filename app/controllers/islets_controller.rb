class IsletsController < ApplicationController
  before_action :set_islet, only: [:show, :edit, :update, :destroy]

  def index
    @islets = Islet.joins(:room).order('rooms.name asc, islets.name asc')
  end

  # GET /islets/new
  def new
    @islet = Islet.new
  end

  # GET /islets/1/edit
  def edit
  end

  # POST /islets
  # POST /islets.json
  def create
    @islet = Islet.new(islet_params)

    respond_to do |format|
      if @islet.save
        format.html { redirect_to islets_url, notice: 'Islet was successfully created.' }
        format.json { render :show, status: :created, location: @islet }
      else
        format.html { render :new }
        format.json { render json: @islet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /islets/1
  # PATCH/PUT /islets/1.json
  def update
    respond_to do |format|
      if @islet.update(islet_params)
        format.html { redirect_to islets_url, notice: 'Islet was successfully updated.' }
        format.json { render :show, status: :ok, location: @islet }
      else
        format.html { render :edit }
        format.json { render json: @islet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /islets/1
  # DELETE /islets/1.json
  def destroy
    @islet.destroy
    respond_to do |format|
      format.html { redirect_to islets_url, notice: 'Islet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_islet
    @islet = Islet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def islet_params
    params.require(:islet).permit(:name, :room_id)
  end
end
