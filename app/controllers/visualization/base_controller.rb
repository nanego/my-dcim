# frozen_string_literal: true

module Visualization
  class BaseController < ApplicationController
    include InventoriesSidebarHelper

    before_action :hide_inventories_sidebar!
  end
end
