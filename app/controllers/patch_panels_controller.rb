class PatchPanelsController < ApplicationController

  def index
    @patch_panels_by_frame = Server.patch_panels.index_by { |patch_panel| "#{patch_panel.room} #{patch_panel.frame} #{patch_panel}" }.sort.to_h
  end

  def show
    @patch_panel = Server.friendly.patch_panels.find(params[:id].to_s.downcase)
    @patch_panel_ports = @patch_panel.ports
    @destination_ports = @patch_panel_ports.map(&:paired_connection).map(&:port)
    @destination_servers = @destination_ports.map(&:server).uniq.sort{|a,b|b.position<=>a.position}
  end
end
