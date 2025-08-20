# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecordSetting do
  subject(:settings) { described_class.new(attributes) }

  let(:attributes) { {} }

  describe "#category_ids" do
    it { expect(settings.category_ids).to eq([1]) }
  end

  describe "#save" do
    let(:attributes) { { category_ids: [2] } }

    it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect(categories(:one).is_glpi_synchronizable).to be(true)
      expect(categories(:two).is_glpi_synchronizable).to be(false)

      settings.save
      categories(:one).reload
      categories(:two).reload

      expect(categories(:one).is_glpi_synchronizable).to be(false)
      expect(categories(:two).is_glpi_synchronizable).to be(true)
    end
  end
end
