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
end
