# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable
module InventoriesSidebarHelper
  def hide_inventories_sidebar?
    @_hide_inventories_sidebar || false
  end

  def hide_inventories_sidebar!
    @_hide_inventories_sidebar = true
  end
end
# rubocop:enable Rails/HelperInstanceVariable
