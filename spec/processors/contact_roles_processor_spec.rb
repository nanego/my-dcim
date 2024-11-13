# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactRolesProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { ContactRole.all }
  let(:params) { {} }

  describe "when sorting" do
    pending "TODO"
  end
end
