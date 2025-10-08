# frozen_string_literal: true

module FormHelper
  def redirect_to_on_success_hidden_field_tag(redirect_to_on_success)
    hidden_field_tag(:redirect_to_on_success, redirect_to_on_success) if redirect_to_on_success
  end
end
