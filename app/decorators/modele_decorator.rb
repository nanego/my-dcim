# frozen_string_literal: true

class ModeleDecorator < ApplicationDecorator
  include ActionView::Helpers::AssetTagHelper

  def network_types_to_human
    return Modele.human_attribute_name("network_types.blank") unless (n_t = network_types.presence)

    n_t.map { |type| Modele.human_attribute_name("network_types.#{type}") }.join(", ")
  end

  def displays_to_human
    return tag.span(I18n.t(".modeles.decorator.no_enclosure"), class: "fst-italic fw-light text-body-secondary") unless enclosures.any?

    enclosures.map do |enclosure|
      Enclosure.human_attribute_name("display.#{enclosure.display}")
    end.join(", ")
  end
end
