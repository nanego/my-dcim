# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_contact, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Contact.model_name.human.pluralize, contacts_path)
  end

  # GET /contacts
  # GET /contacts.json
  def index
    @filter = ProcessorFilter.new(Contact.all, params)
    @contacts = @filter.results
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show; end

  # GET /contacts/new
  def new
    authorize! @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit; end

  # POST /contacts
  # POST /contacts.json
  def create
    authorize! @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to_new_or_to(@contact, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to contact_path(@contact), notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    if @contact.destroy
      respond_to do |format|
        format.html { redirect_to contacts_path, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to(contacts_path, alert: @contact.errors.full_messages_for(:base).join(", ")) }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    authorize! @contact = Contact.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.expect(contact: %i[first_name last_name phone_number email organization])
  end
end
