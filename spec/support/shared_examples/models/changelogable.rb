# frozen_string_literal: true

shared_examples_for "changelogable" do |object: nil, new_attributes:|
  let(:new_object) do
    if object.is_a?(Proc)
      instance_exec(&object)
    else
      described_class.new
    end
  end

  context "when created" do
    let(:created) do
      new_object.save!
      new_object
    end

    it { expect(created.changelog_entries.count).to eq(1) }
    it { expect(created.changelog_entries.order(created_at: :desc).first.action).to eq("create") }
  end

  context "when updated" do
    let(:updated) do
      new_object.update!(new_attributes)
      new_object
    end

    before do
      new_object.save!
    end

    it { expect { updated }.to change(ChangelogEntry, :count).by(1) }
    it { expect(updated.changelog_entries.count).to eq(2) }
    it { expect(updated.changelog_entries.order(created_at: :desc).first.action).to eq("update") }
  end

  context "when destroyed" do
    let(:destroyed) do
      new_object.destroy!
      new_object
    end

    before do
      new_object.save!
    end

    it { expect { destroyed }.to change(ChangelogEntry, :count).by(1) }
    it { expect(destroyed.changelog_entries.count).to eq(2) }
    it { expect(destroyed.changelog_entries.order(created_at: :desc).first.action).to eq("destroy") }
  end
end
