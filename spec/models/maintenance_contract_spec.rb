# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MaintenanceContract, type: :model do
  it_behaves_like "changelogable", new_attributes: { start_date: Time.zone.now.to_date }

  describe "associations" do
    it { is_expected.to belong_to(:maintainer).optional(true) }
    it { is_expected.to belong_to(:contract_type).optional(true) }
    it { is_expected.to belong_to(:server).optional(true) }
  end
end
