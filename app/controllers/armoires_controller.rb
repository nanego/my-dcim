class ArmoiresController < ApplicationController
  before_action :set_armoire, only: [:show, :edit, :update, :destroy]

  # GET /armoires
  # GET /armoires.json
  def index
    @armoires = Armoire.all
  end

  # GET /armoires/1
  # GET /armoires/1.json
  def show
  end

  # GET /armoires/new
  def new
    @armoire = Armoire.new
  end

  # GET /armoires/1/edit
  def edit
  end

  # POST /armoires
  # POST /armoires.json
  def create
    @armoire = Armoire.new(armoire_params)

    respond_to do |format|
      if @armoire.save
        format.html { redirect_to @armoire, notice: 'Armoire was successfully created.' }
        format.json { render :show, status: :created, location: @armoire }
      else
        format.html { render :new }
        format.json { render json: @armoire.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /armoires/1
  # PATCH/PUT /armoires/1.json
  def update
    respond_to do |format|
      if @armoire.update(armoire_params)
        format.html { redirect_to @armoire, notice: 'Armoire was successfully updated.' }
        format.json { render :show, status: :ok, location: @armoire }
      else
        format.html { render :edit }
        format.json { render json: @armoire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /armoires/1
  # DELETE /armoires/1.json
  def destroy
    @armoire.destroy
    respond_to do |format|
      format.html { redirect_to armoires_url, notice: 'Armoire was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_armoire
      @armoire = Armoire.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def armoire_params
      params.require(:armoire).permit(:title, :description, :published)
    end
end
