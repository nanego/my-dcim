# frozen_string_literal: true

module Bulk
  class ContactAssignmentsController < BaseController
    before_action :set_contact_assignments

    def destroy
      respond_to do |format|
        if @contact_assignments.map(&:destroy).all?
          format.html { redirect_to contact_assignments_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: ContactAssignment.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to contact_assignments_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: ContactAssignment.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_contact_assignments
      @contact_assignments = ContactAssignment.where(id: params[:ids])
    end
  end
end
