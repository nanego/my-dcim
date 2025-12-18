# frozen_string_literal: true

class CardTypesController < ApplicationController
  before_action :set_card_type, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(CardType.model_name.human(count: 2), card_types_path)
  end

  def index
    @filter = ProcessorFilter.new(CardType.sorted, params)
    authorize! @card_types = @filter.results

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show; end

  def new
    authorize! @card_type = CardType.new
  end

  def edit; end

  def create
    authorize! @card_type = CardType.new(card_type_params)

    respond_to do |format|
      if @card_type.save
        format.html { redirect_to_new_or_to(card_type_path(@card_type), notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @card_type }
      else
        format.html { render :new }
        format.json { render json: @card_type.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /card_types/1
  # PATCH/PUT /card_types/1.json
  def update
    respond_to do |format|
      if @card_type.update(card_type_params)
        format.html { redirect_to card_type_path(@card_type), notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @card_type }
      else
        format.html { render :edit }
        format.json { render json: @card_type.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /card_types/1
  # DELETE /card_types/1.json
  destroy_confirmation
  def destroy
    if @card_type.destroy
      respond_to do |format|
        format.html { redirect_to card_types_path, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to card_types_path, alert: @card_type.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_card_type
    authorize! @card_type = CardType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def card_type_params
    params.expect(card_type: %i[name port_type_id port_quantity
                                columns rows first_position max_aligned_ports])
  end
end
