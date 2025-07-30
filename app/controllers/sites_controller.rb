# frozen_string_literal: true

class SitesController < ApplicationController
  before_action :set_site, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Site.model_name.human.pluralize, sites_path)
  end

  def index
    @sites = sorted Site.sorted
  end

  def show; end

  def new
    authorize! @site = Site.new
    @site.contact_assignments.build
  end

  def edit
    @site.contact_assignments.build
  end

  def create
    authorize! @site = Site.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to_new_or_to(@site, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @site }
      else
        format.html { render :new }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to @site, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @site.destroy
      respond_to do |format|
        format.html { redirect_to sites_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to sites_url, alert: @site.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_site
    authorize! @site = Site.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    params.expect(
      site: [
        :name, :description, :position, :street, :country, :city, :latitude, :longitude,
        :delivery_address, :delivery_times, :delivery_map,
        { contact_assignments_attributes: [%i[contact_id contact_role_id id _destroy]] },
      ]
    )
  end
end
