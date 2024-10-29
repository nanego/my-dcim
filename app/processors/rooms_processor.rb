# frozen_string_literal: true

class RoomsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name position sites.name islets_count display_on_home_page status].freeze

  map :q do |q:|
    raw.where(Room.arel_table[:name].matches("%#{q}%"))
  end

  map :site_id do |site_id:|
    raw.where(site_id: site_id)
  end

  sortable fields: SORTABLE_FIELDS
end
