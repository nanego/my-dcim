# frozen_string_literal: true

class StacksController < ApplicationController
  before_action :set_stack, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Stack.model_name.human.pluralize, stacks_path)
  end

  # GET /stacks
  # GET /stacks.json
  def index
    authorize!(@stacks = sorted(Stack.all))
  end

  # GET /stacks/1
  # GET /stacks/1.json
  def show; end

  # GET /stacks/new
  def new
    authorize! @stack = Stack.new
  end

  # GET /stacks/1/edit
  def edit; end

  # POST /stacks
  # POST /stacks.json
  def create
    authorize! @stack = Stack.new(stack_params)

    respond_to do |format|
      if @stack.save
        format.html { redirect_to_new_or_to(@stack, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @stack }
      else
        format.html { render :new }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stacks/1
  # PATCH/PUT /stacks/1.json
  def update
    respond_to do |format|
      if @stack.update(stack_params)
        format.html { redirect_to stack_path(@stack), notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @stack }
      else
        format.html { render :edit }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stacks/1
  # DELETE /stacks/1.json
  def destroy
    if @stack.destroy
      respond_to do |format|
        format.html { redirect_to stacks_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to stacks_url, alert: @stack.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stack
    authorize! @stack = Stack.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stack_params
    params.expect(stack: %i[name color])
  end
end
