# frozen_string_literal: true

module Localization
  extend ActiveSupport::Concern

  included do
    before_action :set_locale

    private

    def set_locale
      stored_locale = current_user&.locale
      I18n.locale =
        if stored_locale && I18n.available_locales.include?(stored_locale.to_sym)
          stored_locale
        else
          I18n.default_locale
        end
    end
  end
end
