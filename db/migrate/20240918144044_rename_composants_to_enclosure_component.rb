class RenameComposantsToEnclosureComponent < ActiveRecord::Migration[7.1]
  def change
    rename_table :composants, :enclosure_components
  end
end
