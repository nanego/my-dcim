# frozen_string_literal: true

require "rails_helper"

RSpec.describe InventoriesSidebarHelper do
  describe "hide_inventories_sidebar?" do
    it { expect(helper.hide_inventories_sidebar?).to be(false) }

    context "when hide_inventories_sidebar! as been called before" do
      before { helper.hide_inventories_sidebar! }

      it { expect(helper.hide_inventories_sidebar?).to be(true) }
    end
  end
end
