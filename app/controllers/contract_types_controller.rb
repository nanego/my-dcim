class ContractTypesController < ApplicationController
  before_action :set_contract_type, only: [:show, :edit, :update, :destroy]

  # GET /contract_types
  # GET /contract_types.json
  def index
    @contract_types = ContractType.all
  end

  # GET /contract_types/1
  # GET /contract_types/1.json
  def show
  end

  # GET /contract_types/new
  def new
    @contract_type = ContractType.new
  end

  # GET /contract_types/1/edit
  def edit
  end

  # POST /contract_types
  # POST /contract_types.json
  def create
    @contract_type = ContractType.new(contract_type_params)

    respond_to do |format|
      if @contract_type.save
        format.html { redirect_to @contract_type, notice: 'Contract type was successfully created.' }
        format.json { render :show, status: :created, location: @contract_type }
      else
        format.html { render :new }
        format.json { render json: @contract_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contract_types/1
  # PATCH/PUT /contract_types/1.json
  def update
    respond_to do |format|
      if @contract_type.update(contract_type_params)
        format.html { redirect_to @contract_type, notice: 'Contract type was successfully updated.' }
        format.json { render :show, status: :ok, location: @contract_type }
      else
        format.html { render :edit }
        format.json { render json: @contract_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contract_types/1
  # DELETE /contract_types/1.json
  def destroy
    @contract_type.destroy
    respond_to do |format|
      format.html { redirect_to contract_types_url, notice: 'Contract type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract_type
      @contract_type = ContractType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contract_type_params
      params.require(:contract_type).permit(:name)
    end
end
