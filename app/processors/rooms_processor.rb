# frozen_string_literal: true

class RoomsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name position sites.name islets_count display_on_home_page status].freeze

  map :q do |q:|
    raw.where(Room.arel_table[:name].matches("%#{q}%"))
  end

  map :site_ids, filter_with: :non_empty_array do |site_ids:|
    raw.joins(:site).where(site_id: site_ids)
  end

  sortable fields: SORTABLE_FIELDS
end
