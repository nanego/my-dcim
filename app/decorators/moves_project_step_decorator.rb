# frozen_string_literal: true

class MovesProjectStepDecorator < ApplicationDecorator
  class << self
    include ActionView::Helpers::FormOptionsHelper

    def grouped_by_project_options_for_select
      grouped_steps = MovesProjectStep.joins(:moves_project)
        .merge(MovesProject.unarchived)
        .group_by(&:moves_project)
        .map do |moves_project, steps|
        [moves_project.to_s, steps.map { |step| [step.to_s, step.id] }]
      end

      grouped_options_for_select(grouped_steps)
    end
  end
end
