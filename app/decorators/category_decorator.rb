# frozen_string_literal: true

class CategoryDecorator < ApplicationDecorator
  class << self
    def glpi_sync_options_for_select
      Category.glpi_syncs.keys.map { |key| [glpi_sync_human_for(key), key] }
    end

    def glpi_sync_human_for(glpi_sync)
      Category.human_attribute_name("#{glpi_sync}_glpi_sync")
    end
  end

  def glpi_sync_human
    CategoryDecorator.glpi_sync_human_for glpi_sync
  end
end
