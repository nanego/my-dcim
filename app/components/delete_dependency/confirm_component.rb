# frozen_string_literal: true

module DeleteDependency
  class ConfirmComponent < ApplicationComponent
    erb_template <<~ERB
      <% if @dependencies.empty? %>

        <p><%= t(".confirm") %></p>

        <%= render ButtonComponent.new(
          t("action.cancel"),
          url: :back,
          variant: :info,
          is_responsive: true
        )%>

        <%= render ButtonComponent.new(
          t("action.delete"),
          url: @full_delete_path,
          method: :delete,
          variant: :danger,
          icon: "trash",
          is_responsive: true,
        )%>

      <% else %>

        <p><%= t(".dependency_exist_message") %></p>

        <div class="d-flex flex-wrap gap-3">
          <% @dependencies.each do |dependency| %>
            <div>
              <%= render component_for(dependency[:klass], dependency[:records], dependency[:asso_name]) %>
            </div>
          <% end %>
        </div>
      <% end %>
    ERB

    def initialize(record, full_delete_path)
      @dependencies = record.delete_dependencies
      @full_delete_path = full_delete_path
      super
    end

    private

    def component_for(model, records, asso_name)
      class_name = "DeleteDependency::#{model.model_name.name}CollectionComponent"
      component_class = class_name.safe_constantize
      return component_class.new(records, asso_name) unless component_class.nil?

      DeleteDependency::DefaultsComponent.new model, records, asso_name
    end
  end
end
