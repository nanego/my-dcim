class ModelesController < ApplicationController

  include ModelesHelper

  before_action :set_modele, only: [:show, :edit, :update, :destroy]

  def index
    @modeles = Modele.order(:title)
    @types = @modeles.group_by { |m| m.category.title }.sort_by { |categorie, modeles| categorie.to_s }
  end

  def show
  end

  def new
    @modele = Modele.new
  end

  def edit
    unless @modele.color.present?
      @modele.color = lighten_color("##{Digest::MD5.hexdigest(@modele.try(:title) || 'test')[0..5]}", 0.4)
    end
  end

  def create
    @modele = Modele.new(modele_params)

    respond_to do |format|
      if @modele.save
        format.html { redirect_to @modele, notice: 'Modele was successfully created.' }
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
        format.html { redirect_to edit_modele_path(@modele), notice: 'Le modèle a été mis à jour.' }
        format.json { render :show, status: :ok, location: @modele }
      else
        format.html { render :edit }
        format.json { render json: @modele.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @modele.destroy
    respond_to do |format|
      format.html { redirect_to modeles_url, notice: 'Modele was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modele
      @modele = Modele.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modele_params
      params.require(:modele).permit(:title, :color, :description, :published, :category_id, :architecture_id, :u, :marque_id, :nb_elts, composants_attributes: [:type_composant_id, :modele_id, :position, :_destroy, :id, slots_attributes: [:valeur, :_destroy, :id, :position]])
    end
end
