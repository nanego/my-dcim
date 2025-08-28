# frozen_string_literal: true

class MoveDecorator < ApplicationDecorator
  include ActionView::Helpers

  def status_to_badge_component
    text = I18n.t(".activerecord.attributes.move.statuses.#{status}")
    color = executed? ? :success : :primary

    BadgeComponent.new(text, color:, variant: :pill)
  end

  def steps_options_for_select
    options_for_select(moves_project.steps.pluck(:name, :id), { selected: moves_project_step_id })
  end
end
