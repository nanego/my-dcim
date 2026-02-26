# frozen_string_literal: true

module Bulk
  class ServersController < BaseController
    before_action :set_servers

    def destroy
      respond_to do |format|
        if @servers.map(&:destroy).all?
          format.html { redirect_to servers_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Server.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to servers_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Room.model_name.human), status: :see_other }
        end
      end
    end

    def export_cables
      render ferrum_pdf: { scale: 1.2 },
             layout: "pdf",
             filename: "export-cables.pdf",
             disposition: :inline
    end

    private

    def scoped_servers
      authorized_scope(Server.no_pdus)
    end

    def set_servers
      authorize! @servers = scoped_servers.where(id: params[:ids])
    end
  end
end
