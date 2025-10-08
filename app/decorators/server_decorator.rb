# frozen_string_literal: true

class ServerDecorator < ApplicationDecorator
  def network_types_to_human
    return Modele.human_attribute_name("network_types.blank") unless (n_t = network_types.presence)

    n_t.map { |type| Modele.human_attribute_name("network_types.#{type}") }.join(", ")
  end

  def full_name
    [modele&.category, name].compact.join(" ")
  end

  def confirm_delete_message
    return I18n.t("action.confirm") unless moves.any?

    described_moves = decorate(moves).map(&:name).join("\n- ")

    I18n.t("moves.decorator.confirm_delete_message", moves: described_moves)
  end
end
