# frozen_string_literal: true

RSpec.configure do |config|
  config.include ActionView::Helpers::TranslationHelper

  config.after { I18n.locale = I18n.default_locale } # rubocop:disable Rails/I18nLocaleAssignment
end
