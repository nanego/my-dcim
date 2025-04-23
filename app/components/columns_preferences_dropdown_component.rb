# frozen_string_literal: true

class ColumnsPreferencesDropdownComponent < ApplicationComponent
  erb_template <<~ERB
    <section>
      <div class="dropdown d-flex justify-content-end">
        <button type="button" class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
          <%= t(".trigger_modal") %>
        </button>

        <div class="dropdown-menu p-4">
          <%= form_with url: @action_path, method: :get do |form| %>
            <fieldset class="form-floating">
              <% @columns_preferences.available_columns_options.each do |column, column_name| %>
                <div class="form-check">
                  <%= check_box_tag "columns[]", column, @columns_preferences.preferred.include?(column), id: "column_\#{column}", class: "form-check-input" %>
                  <%= form.label "column_\#{column}", column_name, class: "form-check-label" %>
                </div>
              <% end %>
            </fieldset>
            <div class="dropdown-divider my-3"></div>
          <div class="d-flex">
            <%= form.submit t("action.apply"), name: "save", class: "btn btn-primary" %>
            <% end %>

            <%= form_with url: @action_path, method: :get do |form| %>
              <%= form.submit t("action.reset"), name: "reset", class: "btn btn-link" %>
            <% end %>
          </div>
      </div>
    </section>
  ERB

  def initialize(action_path, columns_preferences)
    @action_path = action_path
    @columns_preferences = columns_preferences

    super
  end
end
