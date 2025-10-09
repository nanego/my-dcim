# frozen_string_literal: true

class CardEmptyDataComponentPreview < ViewComponent::Preview
  # @param icon text "Add an icon name from the https://icons.getbootstrap.com/"
  # @param text text
  def default(icon: "table", text: nil)
    render CardEmptyDataComponent.new(icon:, text:)
  end
end
