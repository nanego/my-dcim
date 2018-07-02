class CardTypesController < ApplicationController
  before_action :set_card_type, only: [:show, :edit, :update, :destroy]

  def index
    @card_types = CardType.sorted
  end

  def show
  end

  def new
    @card_type = CardType.new
  end

  def edit
  end

  def create
    @card_type = CardType.new(card_type_params)

    respond_to do |format|
      if @card_type.save
        format.html {redirect_to({action: 'index'}, notice: 'card_type was successfully created.')}
        format.json {render :show, status: :created, location: @card_type}
      else
        format.html {render :new}
        format.json {render json: @card_type.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /card_types/1
  # PATCH/PUT /card_types/1.json
  def update
    respond_to do |format|
      if @card_type.update(card_type_params)
        format.html {redirect_to({action: 'index'}, notice: 'card_type was successfully updated.')}
        format.json {render :show, status: :ok, location: @card_type}
      else
        format.html {render :edit}
        format.json {render json: @card_type.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /card_types/1
  # DELETE /card_types/1.json
  def destroy
    @card_type.destroy
    respond_to do |format|
      format.html {redirect_to({action: 'index'}, notice: 'card_type was successfully destroyed.')}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_card_type
    @card_type = CardType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def card_type_params
    params.require(:card_type).permit(:name, :port_type_id, :port_quantity,
                                      :columns, :rows, :orientation, :max_aligned_ports)
  end
end
