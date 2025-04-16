# frozen_string_literal: true

class ColumnsPreferencesModalComponentPreview < ViewComponent::Preview
  def default
    render ColumnsPreferencesModalComponent.new("#", ColumnsPreferences::Columns.new(
                                                       model: Server,
                                                       default: %w[id name],
                                                       available: %w[id name numero],
                                                       preferred: %w[id name]
                                                     ))
  end
end
