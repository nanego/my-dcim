# frozen_string_literal: true

module HasAccessControl
  extend ActiveSupport::Concern

  included do
    enum :access_control, { badge: 0, key: 1, key_loken: 2 }
  end
end
