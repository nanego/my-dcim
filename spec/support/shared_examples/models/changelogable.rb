# frozen_string_literal: true

shared_examples_for "changelogable" do |attribute_name:, new_value:|
  let(:klass) { described_class }
  let(:object) { klass.new }

  context "when created" do
    let(:created) do
      object.save!
      object
    end

    it { expect { created }.to change(ChangelogEntry, :count).by(1) }
    it { expect(created.changelog_entries.last.action).to eq("create") }
  end

  context "when updated" do
    let(:updated) do
      object.update!(attribute_name => new_value)
      object
    end

    before do
      object.save!
    end

    it { expect { updated }.to change(ChangelogEntry, :count).by(1) }
    it { expect(updated.changelog_entries.last.action).to eq("update") }
  end

  context "when destroyed" do
    let(:destroyed) do
      object.destroy!
      object
    end

    before do
      object.save!
    end

    it { expect { destroyed }.to change(ChangelogEntry, :count).by(1) }
    it { expect(destroyed.changelog_entries.last.action).to eq("destroy") }
  end
end
