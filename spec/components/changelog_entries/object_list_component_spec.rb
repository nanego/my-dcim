# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChangelogEntries::ObjectListComponent, type: :component do
  context "with object" do
    let(:islet) { islets(:one) }
    let(:component) { described_class.new(islet) }
    let(:rendered_component) { render_inline(component) }

    it "renders component" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag('turbo-frame', with: {
        id: "changelog-entries",
        src: "/islets/#{islet.id}/changelog_entries"
      }) do
        with_text(I18n.t("changelog_entries.object_list_component.loading"))
        with_tag("span", with: { class: "spinner-grow" })
      end
    end
  end
end
