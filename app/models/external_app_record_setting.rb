# frozen_string_literal: true

class ExternalAppRecordSetting
  include ActiveModel::Model

  attr_accessor :category_glpi_sync_types

  def initialize(attributes = {})
    @category_glpi_sync_types = Category.glpi_synchronizable.to_h { |c| [c.id, c.glpi_sync_type] }

    super
  end

  def save
    Category.transaction do
      Category.update_all(glpi_sync_type: :none) # rubocop:disable Rails/SkipsModelValidations
      @category_glpi_sync_types.each do |id, glpi_sync_type|
        Category.find(id).update(glpi_sync_type: glpi_sync_type.presence || :none)
      end
    end
  end
end
