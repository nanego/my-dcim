# frozen_string_literal: true

class ServerExporter < BaseExporter
  def modele_category_id(record)
    record.modele.category_id
  end

  def islet_id(record)
    record.frame.bay.islet.id
  end

  def bay_id(record)
    record.frame.bay.id
  end

  def u(record)
    record.modele.u
  end
end
