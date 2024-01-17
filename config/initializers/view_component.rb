# frozen_string_literal: true

Rails.application.configure do
  config.view_component.instrumentation_enabled = true

  config.view_component.preview_paths << Rails.root.join("spec/components/previews")
  config.view_component.default_preview_layout = "component_preview"
end
