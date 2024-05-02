# frozen_string_literal: true

class RoomsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name position sites.name islets_count display_on_home_page].freeze

  map :name do |name:|
    raw.where(Room.arel_table[:name].matches("%#{name}%"))
  end

  map :site_id do |site_id:|
    raw.where(site_id: site_id)
  end

  sortable fields: SORTABLE_FIELDS
end
