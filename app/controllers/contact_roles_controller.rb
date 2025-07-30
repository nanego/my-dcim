# frozen_string_literal: true

class ContactRolesController < ApplicationController
  before_action :set_contact_role, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(ContactRole.model_name.human.pluralize, contact_roles_path)
  end

  # GET /contact_roles
  # GET /contact_roles.json
  def index
    @filter = ProcessorFilter.new(ContactRole.all, params)
    authorize!(@contact_roles = @filter.results)
  end

  # GET /contact_roles/1
  # GET /contact_roles/1.json
  def show; end

  # GET /contact_roles/new
  def new
    authorize! @contact_role = ContactRole.new
  end

  # GET /contact_roles/1/edit
  def edit; end

  # POST /contact_roles
  # POST /contact_roles.json
  def create
    authorize! @contact_role = ContactRole.new(contact_role_params)

    respond_to do |format|
      if @contact_role.save
        format.html { redirect_to_new_or_to(@contact_role, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @contact_role }
      else
        format.html { render :new }
        format.json { render json: @contact_role.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /contact_roles/1
  # PATCH/PUT /contact_roles/1.json
  def update
    respond_to do |format|
      if @contact_role.update(contact_role_params)
        format.html { redirect_to contact_role_path(@contact_role), notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @contact_role }
      else
        format.html { render :edit }
        format.json { render json: @contact_role.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /contact_roles/1
  # DELETE /contact_roles/1.json
  def destroy
    if @contact_role.destroy
      respond_to do |format|
        format.html { redirect_to contact_roles_path, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to(contact_roles_path, alert: @contact_role.errors.full_messages_for(:base).join(", ")) }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact_role
    authorize! @contact_role = ContactRole.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_role_params
    params.expect(contact_role: %i[name description])
  end
end
