# frozen_string_literal: true

class ReplaceRenamedClassesInActivities < ActiveRecord::Migration[5.0]
  def up
    unless defined?(PublicActivity::Activity)
      warn "This migration is not used anymore, public_activity gem has been removed"
      return
    end

    PublicActivity::Activity.where(trackable_type: 'Card').update_all(trackable_type: 'CardType')
    PublicActivity::Activity.where(trackable_type: 'CardsServer').update_all(trackable_type: 'Card')
  end
end
