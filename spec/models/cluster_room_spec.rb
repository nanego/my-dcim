# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClusterRoom do
  describe "associations" do
    it { is_expected.to belong_to(:cluster) }
    it { is_expected.to belong_to(:room) }
  end
end
