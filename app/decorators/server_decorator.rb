# frozen_string_literal: true

class ServerDecorator < ApplicationDecorator
  class << self
    def for_options(user)
      authorized_scope(Server.sorted, user:).map { |d| [d.name, d.id] }
    end

    def rooms_for_options(user)
      RoomDecorator.for_options(user)
    end

    def islets_for_options(user)
      IsletDecorator.for_options(user)
    end

    def bays_for_options(user)
      BayDecorator.for_options(user)
    end

    def frames_for_options(user)
      FrameDecorator.for_options(user)
    end

    def domains_for_options(user)
      DomaineDecorator.for_options(user)
    end
  end

  def network_types_to_human
    return Modele.human_attribute_name("network_types.blank") unless (n_t = network_types.presence)

    n_t.map { |type| Modele.human_attribute_name("network_types.#{type}") }.join(", ")
  end

  def full_name
    [modele&.category, name].compact.join(" ")
  end
end
