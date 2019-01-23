class MaintainersController < ApplicationController
  before_action :set_maintainer, only: [:show, :edit, :update, :destroy]

  # GET /maintainers
  # GET /maintainers.json
  def index
    @maintainers = Maintainer.all
  end

  # GET /maintainers/1
  # GET /maintainers/1.json
  def show
  end

  # GET /maintainers/new
  def new
    @maintainer = Maintainer.new
  end

  # GET /maintainers/1/edit
  def edit
  end

  # POST /maintainers
  # POST /maintainers.json
  def create
    @maintainer = Maintainer.new(maintainer_params)

    respond_to do |format|
      if @maintainer.save
        format.html { redirect_to @maintainer, notice: 'Maintainer was successfully created.' }
        format.json { render :show, status: :created, location: @maintainer }
      else
        format.html { render :new }
        format.json { render json: @maintainer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintainers/1
  # PATCH/PUT /maintainers/1.json
  def update
    respond_to do |format|
      if @maintainer.update(maintainer_params)
        format.html { redirect_to @maintainer, notice: 'Maintainer was successfully updated.' }
        format.json { render :show, status: :ok, location: @maintainer }
      else
        format.html { render :edit }
        format.json { render json: @maintainer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maintainers/1
  # DELETE /maintainers/1.json
  def destroy
    @maintainer.destroy
    respond_to do |format|
      format.html { redirect_to maintainers_url, notice: 'Maintainer a bien été supprimé.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_maintainer
      @maintainer = Maintainer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def maintainer_params
      params.require(:maintainer).permit(:name)
    end
end
