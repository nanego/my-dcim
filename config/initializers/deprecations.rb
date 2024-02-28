# frozen_string_literal: true

Rails.application.deprecators.disallowed_warnings = [
  "Support for the pre-Ruby 2.4 behavior of to_time",
  "`Rails.application.secrets` is deprecated in favor of `Rails.application.credentials`",
]

Rails.application.deprecators.disallowed_warnings = :all
