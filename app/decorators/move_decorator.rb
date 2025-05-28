# frozen_string_literal: true

class MoveDecorator < ApplicationDecorator
  def status_to_badge_component
    text = I18n.t(".activerecord.attributes.move.statuses.#{status}")
    color = executed? ? :success : :secondary

    BadgeComponent.new(text, color:, variant: :pill)
  end
end
