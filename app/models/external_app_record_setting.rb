# frozen_string_literal: true

class ExternalAppRecordSetting
  include ActiveModel::Model

  attr_accessor :category_ids

  def initialize(attributes = {})
    @category_ids = Category.glpi_synchronizable.ids

    super
  end

  def save
    Category.transaction do
      Category.update_all(is_glpi_synchronizable: false) # rubocop:disable Rails/SkipsModelValidations
      Category.where(id: @category_ids).update_all(is_glpi_synchronizable: true) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
