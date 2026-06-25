# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "accepted_format_for_attachment" do
    context "with a model and attribute using ContentTypeValidator" do
      it do
        expect(helper.accepted_format_for_attachment(Site, "delivery_map")).to eq(
          "image/png, image/jpeg, image/gif, application/pdf",
        )
      end
    end

    context "with a model using ContentTypeValidator (but not the attribute)" do
      it { expect(helper.accepted_format_for_attachment(Site, "name")).to be_nil }
    end

    context "with a model not using ContentTypeValidator" do
      it { expect(helper.accepted_format_for_attachment(Room, "name")).to be_nil }
    end
  end

  describe "#value_with_unit" do
    context "with a value" do
      it { expect(helper.value_with_unit(30, "mm")).to eq("30 mm") }
    end

    context "with a blank value" do
      it { expect(helper.value_with_unit(nil, "mm")).to be_nil }
    end

    context "with an empty value" do
      it { expect(helper.value_with_unit("", "mm")).to be_nil }
    end
  end

  describe "#surface_area_with_suffix" do
    context "with a value" do
      it { expect(helper.surface_area_with_suffix(300)).to eq("300 m²") }
    end

    context "with an empty value" do
      it { expect(helper.value_with_unit("", "mm")).to be_nil }
    end

    context "with a blank value" do
      it { expect(helper.value_with_unit(nil, "mm")).to be_nil }
    end
  end

  describe "#boolean_to_badge_component" do
    subject(:badge) { helper.boolean_to_badge_component(boolean) }

    let(:boolean) { true }

    context "with true" do
      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :success }

      it do
        expect(badge.content).to eq(
          "<span class=\"d-inline-flex align-items-center\"><span class=\"bi bi-check-circle-fill text-success me-2\"></span><span>Oui</span></span>",
        )
      end
    end

    context "with false" do
      let(:boolean) { false }

      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :danger }

      it do
        expect(badge.content).to eq(
          "<span class=\"d-inline-flex align-items-center\"><span class=\"bi bi-x-circle-fill text-danger me-2\"></span><span>Non</span></span>",
        )
      end
    end
  end

  describe "#value_or_nc" do
    context "with a value" do
      it { expect(helper.value_or_nc("value")).to eq("value") }
    end

    context "with a blank value" do
      it { expect(helper.value_or_nc(nil)).to eq("<span class=\"fst-italic fw-light text-body-secondary\">n/c</span>") }
    end

    context "with an empty value" do
      it { expect(helper.value_or_nc("")).to eq("<span class=\"fst-italic fw-light text-body-secondary\">n/c</span>") }
    end
  end
end
