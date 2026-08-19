# frozen_string_literal: true

module Bulk
  module Moves
    class ConnectionsController < BaseController
      before_action :set_move
      before_action :set_move_connections

      def destroy
        respond_to do |format|
          if @move_connections.map(&:destroy).all?
            format.html do
              flash[:notice] = t("bulk.resource.destroy.flashes.destroyed", resource: Move::Connection.model_name.human.pluralize)
              redirect_to move_connections_path(@move), status: :see_other
            end
          else
            # TODO: tell which records has not been removed
            format.html do
              flash[:alert] = t("bulk.resource.destroy.flashes.not_destroyed", resource: Move::Connection.model_name.human)
              redirect_to move_connections_path(@move), status: :see_other
            end
          end
        end
      end

      private

      def scoped_move_connections
        @move.move_connections
      end

      def set_move
        authorize! @move = Move.find(params[:move_id])
      end

      def set_move_connections
        authorize! @move_connections = scoped_move_connections.where(id: params[:ids])
      end
    end
  end
end
