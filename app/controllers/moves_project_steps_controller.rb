# frozen_string_literal: true

class MovesProjectStepsController < ApplicationController
  before_action :set_moves_project
  before_action :set_moves_project_step, only: %i[execute]

  before_action do
    breadcrumb.add_step(MovesProject.model_name.human.pluralize, moves_projects_path)
    breadcrumb.add_step(@moves_project_step.moves_project, moves_project_path(@moves_project_step.moves_project))
    breadcrumb.add_step(Move.model_name.human(count: 2), moves_project_step_moves_path(@moves_project_step)) unless action_name == "index"
  end

  def execute
    @moves_project_step.execute!

    respond_to do |format|
      format.html { redirect_to moves_project_path(@moves_project), notice: t(".flashes.executed") }
      format.json { head :no_content }
    end
  end

  private

  def set_moves_project
    @moves_project = MovesProject.find(params[:moves_project_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_moves_project_step
    @moves_project_step = @moves_project.steps.find(params.expect(:id))
  end
end
