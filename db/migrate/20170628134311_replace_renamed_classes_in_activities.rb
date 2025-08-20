# frozen_string_literal: true

class MigrationPublicActivityActivity < ActiveRecord::Base
  self.table_name = :activities

  belongs_to :trackable, polymorphic: true
end

class ReplaceRenamedClassesInActivities < ActiveRecord::Migration[5.0]
  def up
    MigrationPublicActivityActivity.where(trackable_type: "Card").update_all(trackable_type: "CardType")
    MigrationPublicActivityActivity.where(trackable_type: "CardsServer").update_all(trackable_type: "Card")
  end
end
