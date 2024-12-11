# frozen_string_literal: true

class ModeleDecorator < ApplicationDecorator
  def network_types_to_human
    return Modele.human_attribute_name("network_types.blank") unless (n_t = network_types.presence)

    n_t.map { |type| Modele.human_attribute_name("network_types.#{type}") }.join(", ")
  end

  def displays_to_human
    return nil unless enclosures.any? # TODO : manage "-" in table component

    enclosures.map do |enclosure|
      next Enclosure.human_attribute_name("display.blank") if enclosure.display.nil?

      Enclosure.human_attribute_name("display.#{enclosure.display}")
    end.join(", ")
  end
end
