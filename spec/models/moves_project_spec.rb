# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProject do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:move_project) { described_class.new(name: "A") }

  describe "associations" do
    it { is_expected.to belong_to(:created_by).class_name("User").optional }

    it { is_expected.to have_many(:steps) }
    it { is_expected.to have_many(:moves).through(:steps) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#save" do
    let(:moves_project) { moves_projects(:with_steps) }

    it :aggregate_failures do
      moves_project.assign_attributes(steps_attributes: { id: moves_project.steps[0].id, _destroy: 1 })
      moves_project.save
      moves_project.reload

      expect(moves_project.errors.where(:base, :steps_cannot_be_destroyed).count).to eq(1)
    end

    it do
      expect do
        moves_project.assign_attributes(steps_attributes: { id: moves_project.steps[0].id, _destroy: 1 })
        moves_project.save
        moves_project.reload
      end.not_to raise_error
    end
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
