# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProjectStepsController do
  let(:moves_project_step) { moves_project_steps(:one) }
  let(:moves_project) { moves_project_step.moves_project }

  describe "GET #execute" do
    let(:moves_project_step) { moves_project_steps(:planned) }

    subject(:response) do
      patch execute_moves_project_moves_project_step_path(moves_project, moves_project_step)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(moves_project_path(moves_project)) }
    it { expect { response ; moves(:planned).reload }.to change(moves(:planned), :executed_at).from(nil) }

    context "when executed" do
      let(:move) { moves(:executed) }

      it { expect { response ; moves(:executed).reload }.not_to change(moves(:executed), :executed_at) }
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_project_path(moves_project)) }
    end
  end
end
