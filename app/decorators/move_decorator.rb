# frozen_string_literal: true

class MoveDecorator < ApplicationDecorator
  include ActionView::Helpers

  def steps_options_for_select
    options_for_select(moves_project.steps.pluck(:name, :id), { selected: moves_project_step_id })
  end

  def status_to_badge_component
    text = I18n.t(".activerecord.attributes.move.statuses.#{status}")
    color = executed? ? :success : :primary

    BadgeComponent.new(text, color:, variant: :pill)
  end

  def moved_connections_to_badge_component
    color = remove_existing_connections_on_execution ? :success : :danger

    BadgeComponent.new(I18n.t("boolean.#{remove_existing_connections_on_execution}"), color:, variant: :pill)
  end

  def display_name
    I18n.t("moves.decorator.display_name", moveable:)
  end
end
