class ServerStatesController < ApplicationController
  before_action :set_server_state, only: [:show, :edit, :update, :destroy]

  # GET /server_states
  # GET /server_states.json
  def index
    @server_states = ServerState.all
  end

  # GET /server_states/1
  # GET /server_states/1.json
  def show
  end

  # GET /server_states/new
  def new
    @server_state = ServerState.new
  end

  # GET /server_states/1/edit
  def edit
  end

  # POST /server_states
  # POST /server_states.json
  def create
    @server_state = ServerState.new(server_state_params)

    respond_to do |format|
      if @server_state.save
        format.html { redirect_to @server_state, notice: 'Server state was successfully created.' }
        format.json { render :show, status: :created, location: @server_state }
      else
        format.html { render :new }
        format.json { render json: @server_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /server_states/1
  # PATCH/PUT /server_states/1.json
  def update
    respond_to do |format|
      if @server_state.update(server_state_params)
        format.html { redirect_to @server_state, notice: 'Server state was successfully updated.' }
        format.json { render :show, status: :ok, location: @server_state }
      else
        format.html { render :edit }
        format.json { render json: @server_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /server_states/1
  # DELETE /server_states/1.json
  def destroy
    @server_state.destroy
    respond_to do |format|
      format.html { redirect_to server_states_url, notice: 'Server state was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server_state
      @server_state = ServerState.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def server_state_params
      params.require(:server_state).permit(:title)
    end
end
