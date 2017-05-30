class MarquesController < ApplicationController
  before_action :set_marque, only: [:show, :edit, :update, :destroy]

  # GET /marques
  # GET /marques.json
  def index
    @marques = Marque.all
  end

  # GET /marques/1
  # GET /marques/1.json
  def show
  end

  # GET /marques/new
  def new
    @marque = Marque.new
  end

  # GET /marques/1/edit
  def edit
  end

  # POST /marques
  # POST /marques.json
  def create
    @marque = Marque.new(marque_params)

    respond_to do |format|
      if @marque.save
        format.html { redirect_to @marque, notice: 'Marque was successfully created.' }
        format.json { render :show, status: :created, location: @marque }
      else
        format.html { render :new }
        format.json { render json: @marque.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marques/1
  # PATCH/PUT /marques/1.json
  def update
    respond_to do |format|
      if @marque.update(marque_params)
        format.html { redirect_to @marque, notice: 'Marque was successfully updated.' }
        format.json { render :show, status: :ok, location: @marque }
      else
        format.html { render :edit }
        format.json { render json: @marque.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marques/1
  # DELETE /marques/1.json
  def destroy
    @marque.destroy
    respond_to do |format|
      format.html { redirect_to marques_url, notice: 'Marque was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marque
      @marque = Marque.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marque_params
      params.require(:marque).permit(:name, :description, :published)
    end
end
