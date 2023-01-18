# frozen_string_literal: true

class ReplaceRenamedClassesInActivities < ActiveRecord::Migration[5.0]
  def up
    PublicActivity::Activity.where(trackable_type: 'Card').update_all(trackable_type: 'CardType')
    PublicActivity::Activity.where(trackable_type: 'CardsServer').update_all(trackable_type: 'Card')
  end
end
