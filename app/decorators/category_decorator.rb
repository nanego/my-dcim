# frozen_string_literal: true

class CategoryDecorator < ApplicationDecorator
  include ActionView::Helpers::AssetTagHelper

  class << self
    def glpi_sync_type_options_for_select
      Category.glpi_sync_types.keys.map { |key| [glpi_sync_type_human_for(key), key] }
    end

    def glpi_sync_type_human_for(glpi_sync_type)
      Category.human_attribute_name("glpi_sync_type.#{glpi_sync_type}")
    end
  end

  def glpi_sync_type_human
    return tag.span(I18n.t("n_a"), class: "fst-italic fw-light text-body-secondary") if glpi_sync_type_none?

    CategoryDecorator.glpi_sync_type_human_for(glpi_sync_type)
  end
end
