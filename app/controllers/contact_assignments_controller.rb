# frozen_string_literal: true

class ContactAssignmentsController < ApplicationController
  before_action :set_contact_assignment, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(ContactAssignment.model_name.human.pluralize, contact_assignments_path)
  end

  # GET /contact_assignments
  # GET /contact_assignments.json
  def index
    @contact_assignments = ContactAssignment.includes(:site, :contact, :contact_role)
    @filter = ProcessorFilter.new(@contact_assignments, params)
    @contact_assignments = @filter.results
  end

  # GET /contact_assignments/1
  # GET /contact_assignments/1.json
  def show; end

  # GET /contact_assignments/new
  def new
    @contact_assignment = ContactAssignment.new
    @contact_assignment.assign_attributes(contact_assignment_params) if params[:contact_assignment].present?
  end

  # GET /contact_assignments/1/edit
  def edit; end

  # POST /contact_assignments
  # POST /contact_assignments.json
  def create
    @contact_assignment = ContactAssignment.new(contact_assignment_params)

    respond_to do |format|
      if @contact_assignment.save
        format.html { redirect_to contact_assignment_path(@contact_assignment), notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @contact_assignment }
      else
        format.html { render :new }
        format.json { render json: @contact_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_assignments/1
  # PATCH/PUT /contact_assignments/1.json
  def update
    respond_to do |format|
      if @contact_assignment.update(contact_assignment_params)
        format.html { redirect_to contact_assignment_path(@contact_assignment), notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @contact_assignment }
      else
        format.html { render :edit }
        format.json { render json: @contact_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_assignments/1
  # DELETE /contact_assignments/1.json
  def destroy
    if @contact_assignment.destroy!
      respond_to do |format|
        format.html { redirect_to contact_assignments_path, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to(contact_assignments_path, alert: @contact_assignment.errors.full_messages_for(:base).join(", ")) }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact_assignment
    @contact_assignment = ContactAssignment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_assignment_params
    params.expect(contact_assignment: %i[site_id contact_id contact_role_id])
  end
end
