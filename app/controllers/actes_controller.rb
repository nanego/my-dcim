class ActesController < ApplicationController
  before_action :set_acte, only: [:show, :edit, :update, :destroy]

  # GET /actes
  # GET /actes.json
  def index
    @actes = Acte.all
  end

  # GET /actes/1
  # GET /actes/1.json
  def show
  end

  # GET /actes/new
  def new
    @acte = Acte.new
  end

  # GET /actes/1/edit
  def edit
  end

  # POST /actes
  # POST /actes.json
  def create
    @acte = Acte.new(acte_params)

    respond_to do |format|
      if @acte.save
        format.html { redirect_to @acte, notice: 'Acte was successfully created.' }
        format.json { render :show, status: :created, location: @acte }
      else
        format.html { render :new }
        format.json { render json: @acte.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /actes/1
  # PATCH/PUT /actes/1.json
  def update
    respond_to do |format|
      if @acte.update(acte_params)
        format.html { redirect_to @acte, notice: 'Acte was successfully updated.' }
        format.json { render :show, status: :ok, location: @acte }
      else
        format.html { render :edit }
        format.json { render json: @acte.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /actes/1
  # DELETE /actes/1.json
  def destroy
    @acte.destroy
    respond_to do |format|
      format.html { redirect_to actes_url, notice: 'Acte was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acte
      @acte = Acte.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acte_params
      params.require(:acte).permit(:title, :description, :published)
    end
end
