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

  map :room_id do |room_id:|
    raw.joins(:room).where(room: { id: room_id })
  end

  map :islet_id do |islet_id:|
    raw.joins(:islet).where(islet: { id: islet_id })
  end

  map :bay_id do |bay_id:|
    raw.joins(:bay).where(bay: { id: bay_id })
  end

  sortable fields: SORTABLE_FIELDS
end
