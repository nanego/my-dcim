# frozen_string_literal: true

require "view_component/test_helpers"

module ViewComponent
  module FormHelpers
    def form_with(object, options = {})
      ActionView::Helpers::FormBuilder.new(object_name, object, template, options)
    end

    def object_name
      object.to_model.model_name.param_key
    end

    def template
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      ActionView::Base.new(lookup_context, {}, ApplicationController.new)
    end
  end
end

RSpec.configure do |config|
  config.include RSpecHtmlMatchers, type: :component

  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::FormHelpers, type: :component

  config.include Capybara::RSpecMatchers, type: :component
end
