# frozen_string_literal: true

class ServerDecorator < ApplicationDecorator
  class << self
    def domains_for_options(user)
      user.permitted_domains.sorted.map { |d| [d.name, d.id] }
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
