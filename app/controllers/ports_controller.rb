class PortsController < ApplicationController

  def index
    @baie = Baie.find_by_id(params[:baie_id])
    @salle = @baie.salle
    @serveurs = @baie.serveurs.includes(:cards_serveurs => [:ports, :composant]).order('position desc')
  end

  def edit
    if params[:id].present? && params[:id].to_i > 0
      @port = Port.find_by_id(params[:id])
    else
      @port = Port.create(position: params['position'], parent_id: params['parent_id'], parent_type: params['parent_type'], vlans: params['vlans'], color: params['color'], cablename: params['cablename'])
    end
  end

  def update
    @port = Port.find_by_id(params[:id])
    respond_to do |format|
      if @port.update(port_params)
        format.html { redirect_to @port.parent.serveur, notice: 'Le port a été mis à jour.' }
        format.json { render :show, status: :ok, location: @port.serveur }
      else
        format.html { render :edit }
        format.json { render json: @port.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def port_params
      params.required(:port).permit(:position, :parent_id, :parent_type, :vlans, :color, :cablename)
    end

end
