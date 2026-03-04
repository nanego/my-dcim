# frozen_string_literal: true

class CategoryDecorator < ApplicationDecorator
  include ActionView::Helpers::AssetTagHelper

  class << self
    def glpi_sync_options_for_select
      Category.glpi_syncs.keys.map { |key| [glpi_sync_human_for(key), key] }
    end

    def glpi_sync_human_for(glpi_sync)
      Category.human_attribute_name("#{glpi_sync}_glpi_sync")
    end
  end

  def glpi_sync_human
    return tag.span(I18n.t("n_a"), class: "fst-italic fw-light text-body-secondary") if glpi_sync == "no"

    CategoryDecorator.glpi_sync_human_for glpi_sync
  end
end
