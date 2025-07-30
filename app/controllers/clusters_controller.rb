# frozen_string_literal: true

class ClustersController < ApplicationController
  before_action :set_cluster, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Cluster.model_name.human.pluralize, clusters_path)
  end

  # GET /clusters
  # GET /clusters.json
  def index
    authorize! @clusters = Cluster.includes(:servers).sorted
    @filter = ProcessorFilter.new(@clusters, params)
    @clusters = @filter.results
  end

  # GET /clusters/1
  # GET /clusters/1.json
  def show; end

  # GET /clusters/new
  def new
    authorize! @cluster = Cluster.new
  end

  # GET /clusters/1/edit
  def edit; end

  # POST /clusters
  # POST /clusters.json
  def create
    authorize! @cluster = Cluster.new(cluster_params)

    respond_to do |format|
      if @cluster.save
        format.html { redirect_to_new_or_to(@cluster, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @cluster }
      else
        format.html { render :new }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clusters/1
  # PATCH/PUT /clusters/1.json
  def update
    respond_to do |format|
      if @cluster.update(cluster_params)
        format.html { redirect_to @cluster, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @cluster }
      else
        format.html { render :edit }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clusters/1
  # DELETE /clusters/1.json
  def destroy
    if @cluster.destroy
      respond_to do |format|
        format.html { redirect_to clusters_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to clusters_url, alert: @cluster.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cluster
    authorize! @cluster = Cluster.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cluster_params
    params.expect(cluster: [:name])
  end
end
