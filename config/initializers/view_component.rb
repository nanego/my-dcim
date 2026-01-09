# frozen_string_literal: true

Rails.application.configure do
  config.view_component.instrumentation_enabled = Rails.env.development?

  config.view_component.previews.paths << Rails.root.join("spec/components/previews")
  config.view_component.previews.default_layout = "component_preview"
end
