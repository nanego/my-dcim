class BaiesController < ApplicationController
  include ServeursHelper

  def show
    @baie = Baie.friendly.find(params[:id].to_s.downcase)
    @salle = @baie.salle
    @serveurs_par_baies = {}
    @serveurs = @baie.serveurs.includes(:gestion, :modele => :category, :cards => :port_type, :cards_serveurs => [:composant, :ports])
    @serveurs.each do |s|
      ilot = @baie.ilot
      @serveurs_par_baies[ilot] ||= {}
      @serveurs_par_baies[ilot][@baie] ||= []
      @serveurs_par_baies[ilot][@baie] << s
    end
    @sums = calculate_ports_sums(@baie, @serveurs)

    respond_to do |format|
      format.html do
        render 'salles/show.html.erb'
      end
      format.pdf do
        render layout: 'pdf.html',
               template: "salles/show.pdf.erb",
               show_as_html: params[:debug].present?,
               pdf: 'baie',
               zoom: 0.75
      end
      format.txt { send_data Baie.to_txt(@serveurs_par_baies) }
    end
  end

  def edit
    @baie = Baie.friendly.find(params[:id].to_s.downcase)
  end

  def update
    @baie = Baie.friendly.find(params[:id].to_s.downcase)
    respond_to do |format|
      if @baie.update(baie_params)
        format.html { redirect_to salle_path(@baie.salle), notice: 'baie was successfully updated.' }
        format.json { render :show, status: :ok, location: @baie }
      else
        format.html { render :edit }
        format.json { render json: @baie.errors, status: :unprocessable_entity }
      end
    end
  end

  def sort
    params[:baie].each_with_index do |id, index|
      Baie.where(id: id).update_all(position: index+1)
    end if params[:baie].present?
    render nothing: true
  end

  def index
    @baies = Baie.order("baies.salle_id, baies.position asc")
  end

  def destroy
    @baie = Baie.friendly.find(params[:id].to_s.downcase)
    @baie.destroy
    respond_to do |format|
      format.html { redirect_to baies_url, notice: 'Baie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def baie_params
    params.require(:baie).permit(:title)
  end

end
