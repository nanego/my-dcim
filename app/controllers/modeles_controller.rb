# frozen_string_literal: true

class ModelesController < ApplicationController
  include ModelesHelper

  before_action :set_modele, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Modele.model_name.human.pluralize, modeles_path)
  end

  def index
    authorize! @modeles = Modele.includes(:category, :enclosures).order(:name)
    @filter = ProcessorFilter.new(@modeles, params)
    @modeles = @filter.results

    @types = @modeles.group_by { |m| m.category.name }.sort_by { |categorie, _modeles| categorie.to_s }
  end

  def show
    @servers = @modele.servers
  end

  def new
    authorize! @modele = Modele.new
    @modele.composants.build(:name => 'ALIM')
    @modele.composants.build(:name => 'IPMI')
    @modele.composants.build(:name => 'CM')
    7.times do |i|
      @modele.composants.build(:name => "SL#{i + 1}")
    end
  end

  def edit
    if @modele.color.blank?
      @modele.color = lighten_color("##{Digest::MD5.hexdigest(@modele.name || "test")[0..5]}", 0.4)
    end
  end

  def create
    authorize! @modele = Modele.new(modele_params)

    if params[:preview]
      respond_to do |format|
        format.turbo_stream { render :preview, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        if @modele.save
          format.html { redirect_to_new_or_to(modele_path(@modele), notice: t(".flashes.created")) }
          format.json { render :show, status: :created, location: @modele }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @modele.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @modele.assign_attributes(modele_params)

    if params[:preview]
      respond_to do |format|
        format.turbo_stream { render :preview, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        if @modele.save
          format.html { redirect_to modele_path(@modele), notice: t(".flashes.updated") }
          format.json { render :show, status: :ok, location: @modele }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @modele.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    if @modele.destroy
      respond_to do |format|
        format.html { redirect_to modeles_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to({ action: 'index' }, alert: @modele.errors.full_messages_for(:base).join(", ")) }
      end
    end
  end

  def duplicate
    authorize! to: :duplicate?

    @original_modele = Modele.friendly.find(params[:id].to_s.downcase)
    @modele = @original_modele.deep_dup
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_modele
    authorize! @modele = Modele.friendly.find(params[:id].to_s.downcase)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def modele_params
    params.expect(
      modele: [
        :name, :color, :description, :category_id, :architecture_id, :u, :manufacturer_id, :nb_elts,
        { network_types: [] },
        {
          enclosures_attributes: [[
            :id, :modele_id, :_destroy, :position, :display, :grid_areas,
            { composants_attributes: [%i[enclosure_id name position _destroy id]] },
          ]]
        },
      ]
    )
  end
end
