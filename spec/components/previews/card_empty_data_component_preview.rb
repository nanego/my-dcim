# frozen_string_literal: true

class CardEmptyDataComponentPreview < ViewComponent::Preview
  # @param icon text "Add an icon name from the https://icons.getbootstrap.com/"
  def default(icon: "table")
    render CardEmptyDataComponent.new(icon:)
  end
end
