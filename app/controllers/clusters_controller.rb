# frozen_string_literal: true

class ClustersController < ApplicationController
  before_action :set_cluster, only: [:show, :edit, :update, :destroy]

  # GET /clusters
  # GET /clusters.json
  def index
    @clusters = sorted Cluster.includes(:servers).all
  end

  # GET /clusters/1
  # GET /clusters/1.json
  def show; end

  # GET /clusters/new
  def new
    @cluster = Cluster.new
  end

  # GET /clusters/1/edit
  def edit; end

  # POST /clusters
  # POST /clusters.json
  def create
    @cluster = Cluster.new(cluster_params)

    respond_to do |format|
      if @cluster.save
        format.html { redirect_to @cluster, notice: t(".flashes.created") }
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
    @cluster = Cluster.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cluster_params
    params.require(:cluster).permit(:name)
  end
end
