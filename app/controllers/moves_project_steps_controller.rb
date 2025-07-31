# frozen_string_literal: true

class MovesProjectStepsController < ApplicationController
  before_action :set_moves_project
  before_action :redirect_if_archived, except: %i[frame print]
  before_action :set_moves_project_step, only: %i[frame print execute]
  before_action :set_frame_updated, only: %i[frame print]

  before_action do
    breadcrumb.add_step(MovesProject.model_name.human.pluralize, moves_projects_path)
    breadcrumb.add_step(@moves_project_step.moves_project, moves_project_path(@moves_project_step.moves_project))
    breadcrumb.add_step(@moves_project_step, moves_project_step_moves_path(@moves_project_step)) unless action_name == "index"
  end

  def frame; end

  def print
    render layout: "pdf"
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

  def redirect_if_archived
    return if @moves_project.unarchived?

    redirect_to moves_projects_path, alert: t(".flashes.archived")
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_moves_project_step
    authorize! @moves_project_step = @moves_project.steps.find(params.expect(:id))
  end

  def set_frame_updated
    authorize! @frame = Frame.friendly.find(params[:frame_id]), with: FramePolicy, to: :show?
    @servers = @moves_project_step.servers_moves_for_frame_at_current_step(@frame)
    @moved_connections = MovedConnection.per_servers(@servers)
  end
end
