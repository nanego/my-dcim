# frozen_string_literal: true

class ModelesController < ApplicationController
  include ModelesHelper

  before_action :set_modele, only: [:show, :edit, :update, :destroy]

  def index
    @filter = ProcessorFilter.new(Modele.includes(:category, :enclosures).order(:name), params)
    @modeles = @filter.results

    @types = @modeles.group_by { |m| m.category.name }.sort_by { |categorie, modeles| categorie.to_s }
  end

  def show
    @servers = @modele.servers
  end

  def new
    @modele = Modele.new
    @modele.composants.build(:name => 'ALIM', type_composant_id: 4)
    @modele.composants.build(:name => 'IPMI', type_composant_id: 4)
    @modele.composants.build(:name => 'CM', type_composant_id: 4)
    7.times do |i|
      @modele.composants.build(:name => "SL#{i + 1}", type_composant_id: 4)
    end
  end

  def edit
    if @modele.color.blank?
      @modele.color = lighten_color("##{Digest::MD5.hexdigest(@modele.name || "test")[0..5]}", 0.4)
    end
  end

  def create
    @modele = Modele.new(modele_params)

    respond_to do |format|
      if @modele.save
        format.html { redirect_to modele_path(@modele), notice: 'Nouveau modèle ajouté.' }
        format.json { render :show, status: :created, location: @modele }
      else
        format.html { render :new }
        format.json { render json: @modele.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @modele.update(modele_params)
        format.html { redirect_to modele_path(@modele), notice: 'Le modèle a été mis à jour.' }
        format.json { render :show, status: :ok, location: @modele }
      else
        format.html { render :edit }
        format.json { render json: @modele.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @modele.destroy
      respond_to do |format|
        format.html { redirect_to modeles_url, notice: 'Modele a bien été supprimé.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to({ action: 'index' }, alert: @modele.errors.full_messages_for(:base).join(", ")) }
      end
    end
  end

  def duplicate
    @original_modele = Modele.friendly.find(params[:id].to_s.downcase)
    @modele = @original_modele.deep_dup
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_modele
    @modele = Modele.friendly.find(params[:id].to_s.downcase)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def modele_params
    params.require(:modele).permit(
      :name, :color, :description, :category_id, :architecture_id, :u, :manufacturer_id, :nb_elts,
      network_types: [],
      enclosures_attributes: [
        :id, :modele_id, :_destroy, :position, :display, :grid_areas,
        composants_attributes: [:type_composant_id, :enclosure_id, :name, :position, :_destroy, :id],
      ]
    )
  end
end
