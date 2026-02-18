# frozen_string_literal: true

class ServerDecorator < ApplicationDecorator
  class << self
    def options_for_select(user)
      authorized_scope(Server.no_pdus.sorted, user:).map { |d| [d.name, d.id] }
    end

    def rooms_options_for_select(user)
      RoomDecorator.options_for_select(user)
    end

    def islets_options_for_select(user)
      IsletDecorator.options_for_select(user)
    end

    def bays_options_for_select(user)
      BayDecorator.options_for_select(user)
    end

    def frames_options_for_select(user)
      FrameDecorator.options_for_select(user)
    end

    def domains_options_for_select(user)
      DomaineDecorator.options_for_select(user)
    end
  end

  def network_types_to_human
    return Modele.human_attribute_name("network_types.blank") unless (n_t = network_types.presence)

    n_t.map { |type| Modele.human_attribute_name("network_types.#{type}") }.join(", ")
  end

  def full_name
    [modele&.category, name].compact.join(" ")
  end

  def full_location
    [site, islet.decorated.name_with_room].compact_blank.join(" - ")
  end

  def in_frame_location
    [frame, "U#{position || "?"}"].compact_blank.join(" - ")
  end
end
