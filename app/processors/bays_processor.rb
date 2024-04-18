# frozen_string_literal: true

class BaysProcessor < Rubanok::Processor
  map :q do |q:|
    raw.joins(:frames).where(Frame.arel_table[:name].matches("%#{q}%"))
      .or(raw.where(id: q))
  end

  map :room_id do |room_id:|
    raw.where(room: { id: room_id })
  end

  map :islet_id do |islet_id:|
    raw.where(islet_id: islet_id)
  end
end
