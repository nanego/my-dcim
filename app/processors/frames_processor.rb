# frozen_string_literal: true

class FramesProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name u rooms.name islets.name].freeze

  map :q do |q:|
    raw.where(Frame.arel_table[:name].matches("%#{q}%"))
      .or(raw.where(id: q))
  end

  map :u do |u:|
    raw.where(u: u)
  end

  map :room_ids, filter_with: :non_empty_array do |room_ids:|
    raw.joins(bay: { islet: :room }).where(room: { id: room_ids })
  end

  map :islet_ids, filter_with: :non_empty_array do |islet_ids:|
    raw.joins(bay: :islet).where(islet: { id: islet_ids })
  end

  map :bay_ids, filter_with: :non_empty_array do |bay_ids:|
    raw.joins(:bay).where(bay: { id: bay_ids })
  end

  sortable fields: SORTABLE_FIELDS
end
