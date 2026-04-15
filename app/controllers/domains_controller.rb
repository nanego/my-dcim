# frozen_string_literal: true

class DomainsController < ApplicationController
  before_action :set_domain, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Domain.model_name.human.pluralize, domains_path)
  end

  # GET /domains
  # GET /domains.json
  def index
    @filter = ProcessorFilter.new(scoped_domains.sorted, params)
    authorize! @domains = @filter.results
  end

  # GET /domains/1
  # GET /domains/1.json
  def show; end

  # GET /domains/new
  def new
    authorize! @domain = Domain.new
  end

  # GET /domains/1/edit
  def edit; end

  # POST /domains
  # POST /domains.json
  def create
    authorize! @domain = Domain.new(domain_params)

    respond_to do |format|
      if @domain.save
        format.html { redirect_to_new_or_to(@domain, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @domain }
      else
        format.html { render :new }
        format.json { render json: @domain.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /domains/1
  # PATCH/PUT /domains/1.json
  def update
    respond_to do |format|
      if @domain.update(domain_params)
        format.html { redirect_to @domain, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @domain }
      else
        format.html { render :edit }
        format.json { render json: @domain.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.json
  destroy_confirmation
  def destroy
    if @domain.destroy
      respond_to do |format|
        format.html { redirect_back_to_param_or domains_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back_to_param_or domains_url, alert: @domain.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  def scoped_domains
    authorized_scope(Domain.all)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_domain
    authorize! @domain = scoped_domains.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def domain_params
    params.expect(domain: %i[name description])
  end
end
