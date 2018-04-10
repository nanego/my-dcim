class BaysController < ApplicationController
  include RoomsHelper

  before_action :set_bay, only: [:edit, :update, :destroy, :show]

  def index
    @bays = Bay.joins(:islet => :room).order('rooms.position, islets.name, bays.lane, bays.position')
  end

  def show
    @sort_order = frames_sort_order(params[:view], @bay.lane)
    @servers_per_frames = {}
    @sums = {}
    @bay.frames
        .includes(:islet => [:room],
                  :bay => [:frames],
                  :servers => [:frame,
                               :gestion,
                               :modele => [:category, :composants],
                               :cards => [:composant, :ports => [:connection => :cable], :card_type => :port_type]])
        .order("frames.position #{@sort_order}").each do |frame|

      # sums per frame and per type of port
      @sums[frame.id] = {'XRJ' => 0,'RJ' => 0,'FC' => 0,'IPMI' => 0}

      frame.servers.each do |s|
        islet = frame.bay.islet.name
        @servers_per_frames[islet] ||= {}
        @servers_per_frames[islet][frame.bay.lane] ||= {}
        @servers_per_frames[islet][frame.bay.lane][frame.bay] ||= {}
        @servers_per_frames[islet][frame.bay.lane][frame.bay][frame] ||= []
        @servers_per_frames[islet][frame.bay.lane][frame.bay][frame] << s
        s.ports_per_type.each do |type, sum|
          @sums[frame.id][type] = @sums[frame.id][type].to_i + sum
        end
      end
    end

    respond_to do |format|
      format.html do
        render 'bays/show.html.erb'
      end
      format.pdf do
        render layout: 'pdf.html',
               template: "rooms/show.pdf.erb",
               show_as_html: params[:debug].present?,
               pdf: 'frame',
               zoom: 0.75
      end
      format.txt { send_data Frame.to_txt(@servers_per_frames) }
    end

  end

  def new
    @bay = Bay.new
  end

  def edit
  end

  def create
    @bay = Bay.new(bay_params)

    respond_to do |format|
      if @bay.save
        format.html { redirect_to bays_path, notice: 'la baie a été ajoutée.' }
        format.json { render :show, status: :created, location: @bay }
      else
        format.html { render :new }
        format.json { render json: @bay.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @bay.update(bay_params)
        format.html { redirect_to bays_path, notice: 'La baie a été mise à jour.' }
        format.json { render :show, status: :ok, location: @bay }
      else
        format.html { render :edit }
        format.json { render json: @bay.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bay.destroy
    respond_to do |format|
      format.html { redirect_to bays_url, notice: 'Bay was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bay
      @bay = Bay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bay_params
      params.require(:bay).permit(:name, :lane, :position, :bay_type_id, :islet_id)
    end
end
