# frozen_string_literal: true

module Bulk
  class ContactRolesController < BaseController
    before_action :set_contact_roles

    def destroy
      respond_to do |format|
        if @contact_roles.map(&:destroy).all?
          format.html { redirect_to contact_roles_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: ContactRole.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to contact_roles_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: ContactRole.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_contact_roles
      authorize! @contact_roles = ContactRole.where(id: params[:ids])
    end
  end
end
