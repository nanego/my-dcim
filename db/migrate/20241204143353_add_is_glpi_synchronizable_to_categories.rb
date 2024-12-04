# frozen_string_literal: true

class AddIsGlpiSynchronizableToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :is_glpi_synchronizable, :boolean, default: false, null: false
  end
end
