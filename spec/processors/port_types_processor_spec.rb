# frozen_string_literal: true

require "rails_helper"

RSpec.describe PortTypesProcessor do
  describe "when sorting" do
    subject(:result) { described_class.call(PortType.all, params) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "with sort_by #{field}" do
        let(:params) { { sort_by: field, sort: "asc" } }

        it { expect { result.to_a }.not_to raise_error }
      end
    end
  end
end
