class AddSwitchSlotToBaies < ActiveRecord::Migration[4.2]
  def change
    add_column :baies, :switch_slot, :integer
  end
end
