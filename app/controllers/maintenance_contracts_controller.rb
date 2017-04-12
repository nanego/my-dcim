class MaintenanceContractsController < ApplicationController
  before_action :set_maintenance_contract, only: [:show, :edit, :update, :destroy]

  # GET /maintenance_contracts
  # GET /maintenance_contracts.json
  def index
    @maintenance_contracts = MaintenanceContract.all
  end

  # GET /maintenance_contracts/1
  # GET /maintenance_contracts/1.json
  def show
  end

  # GET /maintenance_contracts/new
  def new
    @maintenance_contract = MaintenanceContract.new
    if params[:server_id]
      @server = Server.find_by_id(params[:server_id])
      @maintenance_contract.server = @server if @server
    else
      redirect_to maintenance_contracts_path
    end
  end

  # GET /maintenance_contracts/1/edit
  def edit
  end

  # POST /maintenance_contracts
  # POST /maintenance_contracts.json
  def create
    @maintenance_contract = MaintenanceContract.new(maintenance_contract_params)

    respond_to do |format|
      if @maintenance_contract.save
        format.html { redirect_to @maintenance_contract.server, notice: 'Contrat de maintenant ajouté.' }
        format.json { render :show, status: :created, location: @maintenance_contract }
      else
        format.html { render :new }
        format.json { render json: @maintenance_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintenance_contracts/1
  # PATCH/PUT /maintenance_contracts/1.json
  def update
    respond_to do |format|
      if @maintenance_contract.update(maintenance_contract_params)
        format.html { redirect_to @maintenance_contract.server, notice: 'Contrat de maintenance modifié.' }
        format.json { render :show, status: :ok, location: @maintenance_contract }
      else
        format.html { render :edit }
        format.json { render json: @maintenance_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maintenance_contracts/1
  # DELETE /maintenance_contracts/1.json
  def destroy
    @maintenance_contract.destroy
    respond_to do |format|
      format.html { redirect_to maintenance_contracts_url, notice: 'Maintenance contract was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_contract
      @maintenance_contract = MaintenanceContract.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def maintenance_contract_params
      params.require(:maintenance_contract).permit(:start_date, :end_date, :maintainer_id, :contract_type_id, :server_id)
    end
end
