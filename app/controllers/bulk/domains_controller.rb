# frozen_string_literal: true

module Bulk
  class DomainsController < BaseController
    before_action :set_domains

    def destroy
      respond_to do |format|
        if @domains.map(&:destroy).all?
          format.html { redirect_to domains_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Domain.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to domains_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Domain.model_name.human), status: :see_other }
        end
      end
    end

    private

    def scoped_domains
      authorized_scope(Domain.all)
    end

    def set_domains
      authorize! @domains = scoped_domains.where(id: params[:ids])
    end
  end
end
