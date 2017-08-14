class CablesController < ApplicationController
  before_action :set_cable, only: [:destroy]

  def destroy
    port_id = params[:redirect_to_port_id]
    @cable.destroy
    respond_to do |format|
      format.html { redirect_to connections_edit_path(from_port_id: port_id), notice: 'Connection was successfully destroyed.' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_cable
    @cable = Cable.find(params[:id])
  end

end
