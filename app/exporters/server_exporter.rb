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

  def manager_id(record)
    record.manager.to_s
  end

  def domain_id(record)
    record.domain.to_s
  end

  def modele_id(record)
    record.modele.to_s
  end

  def frame_id(record)
    record.frame.to_s
  end

  def cluster_id(record)
    record.cluster.to_s
  end

  def stack_id(record)
    record.stack.to_s
  end
end
