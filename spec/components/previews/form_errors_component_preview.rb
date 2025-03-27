# frozen_string_literal: true

class FormErrorsComponentPreview < ViewComponent::Preview
  def default
    render FormErrorsComponent.new(object)
  end

  private

  def object
    Islet.new.tap(&:validate)
  end
end
