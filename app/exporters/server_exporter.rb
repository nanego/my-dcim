# frozen_string_literal: true

class ServerExporter < BaseExporter
  def modele_category_id(record)
    record.modele.category.to_s
  end

  def manufacturer_id(record)
    record.manufacturer.to_s
  end

  def room_id(record)
    record.room.to_s
  end

  def islet_id(record)
    record.islet.to_s
  end

  def bay_id(record)
    record.bay.to_s
  end

  def u(record)
    record.modele.u
  end
end
