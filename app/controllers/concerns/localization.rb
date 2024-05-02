# frozen_string_literal: true

module Localization
  extend ActiveSupport::Concern

  included do
    before_action :set_locale

    private

    def set_locale
      I18n.locale = current_user.locale || I18n.default_locale.to_s
    end
  end
end
