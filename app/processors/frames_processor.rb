# frozen_string_literal: true

class FramesProcessor < Rubanok::Processor
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
end
