# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationDecorator, type: :decorator do
  let(:user) { users(:admin) }

  describe ".authorized_scope" do
    it do
      expect(ServerDecorator.authorized_scope(Server.all, user:))
        .to contain_exactly(
          servers(:one), servers(:two), servers(:with_cluster), servers(:four),
          servers(:hub_network1), servers(:hub_network2), servers(:accesible_to_readers),
        )
    end
  end
end
