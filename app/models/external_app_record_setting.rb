# frozen_string_literal: true

class ExternalAppRecordSetting
  include ActiveModel::Model

  attr_accessor :category_glpi_syncs

  def initialize(attributes = {})
    @category_glpi_syncs = Category.glpi_synchronizable.to_h { |c| [c.id, c.glpi_sync] }

    super
  end

  def save
    Category.transaction do
      Category.update_all(glpi_sync: 0) # rubocop:disable Rails/SkipsModelValidations
      @category_glpi_syncs.each do |id, glpi_sync|
        Category.find(id).update(glpi_sync: Category.glpi_syncs[glpi_sync] || 0)
      end
    end
  end
end
