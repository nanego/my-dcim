class BaiesController < ApplicationController

  def show
    @baie = Baie.find_by_id(params[:id])
    @salle = @baie.salle
    @serveurs_par_baies = {}
    @baie.serveurs.includes(:gestion, :modele => :category).each do |s|
      ilot = @baie.ilot
      @serveurs_par_baies[ilot] ||= {}
      @serveurs_par_baies[ilot][@baie] ||= []
      @serveurs_par_baies[ilot][@baie] << s
    end

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
    @baie = Baie.find_by_id(params[:id])
  end

  def update
    @baie = Baie.find_by_id(params[:id])
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

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def baie_params
    params.require(:baie).permit(:title)
  end

end
