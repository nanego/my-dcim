# frozen_string_literal: true

class ColumnsPreferencesDropdownComponentPreview < ViewComponent::Preview
  def default
    render ColumnsPreferencesDropdownComponent.new("#", ColumnsPreferences::Columns.new(
                                                          model: Server,
                                                          default: %w[id name],
                                                          available: %w[id name numero],
                                                          preferred: %w[id name]
                                                        ))
  end
end
