# frozen_string_literal: true

module DeleteDependency
  class MainComponent < ApplicationComponent
    erb_template <<~ERB
      <% @dependencies.each do |dependency| %>
        <%= render component_for(dependency[:klass], dependency[:records]) %>
      <% end %>
    ERB

    def initialize(record)
      @dependencies = record.delete_dependencies

      super
    end

    private

    def component_for(model, records)
      class_name = "DeleteDependency::#{model.model_name.name}CollectionComponent"
      component_class = class_name.safe_constantize
      return component_class.new(records) unless component_class.nil?

      DeleteDependency::DefaultsComponent.new model, records
    end
  end
end
