# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProject do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:move_project) { described_class.new(name: "A") }

  describe "associations" do
    it { is_expected.to have_many(:steps) }
    it { is_expected.to have_many(:moves).through(:steps) }

    it { is_expected.to belong_to(:created_by).optional.class_name("User") }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#to_s" do
    it { expect(move_project.to_s).to eq("A") }
  end

  describe "#archive!" do
    it do
      expect do
        move_project.archive!
      end.to change(move_project, :archived_at).from(nil)
    end
  end

  describe "#archived?" do
    context "when not archived" do
      it { expect(move_project.archived?).to be_nil }
    end

    context "when archived" do
      subject(:move_project) { described_class.new(name: "A", archived_at: 2.years.ago) }

      it { expect(move_project.archived?).to be(true) }
    end
  end

  describe "#unarchived?" do
    context "when not archived" do
      it { expect(move_project.unarchived?).to be(true) }
    end

    context "when archived" do
      subject(:move_project) { described_class.new(name: "A", archived_at: 2.years.ago) }

      it { expect(move_project.unarchived?).to be(false) }
    end
  end
end
