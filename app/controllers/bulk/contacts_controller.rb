# frozen_string_literal: true

module Bulk
  class ContactsController < BaseController
    before_action :set_contacts

    def destroy
      respond_to do |format|
        if @contacts.map(&:destroy).all?
          format.html { redirect_to contacts_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Contact.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to contacts_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Contact.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_contacts
      @contacts = Contact.where(id: params[:ids])
      authorize! @contacts, with: ContactPolicy
    end
  end
end
