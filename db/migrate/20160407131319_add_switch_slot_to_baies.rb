class AddSwitchSlotToBaies < ActiveRecord::Migration
  def change
    add_column :baies, :switch_slot, :integer
  end
end
