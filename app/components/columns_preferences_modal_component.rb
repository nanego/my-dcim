# frozen_string_literal: true

class ColumnsPreferencesModalComponent < ApplicationComponent
  erb_template <<~ERB
    <section>
      <button type="button" class="btn btn-outline-secondary float-end" data-bs-toggle="modal" data-bs-target="#columnsModal"><%= t(".trigger_modal") %></button>

      <div class="modal fade" id="columnsModal" tabindex="1" aria-labelledby="columnsModalLabel" aria-hidden="true">
        <div class="modal-dialog-scrollable modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="columnsModalLabel">Préférences de colonnes</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <%= form_with url: @action_path, method: :get do |form| %>
            <div class="modal-body">
              <fieldset class="form-floating">
                <% @columns_preferences.available_columns_options.each do |column, column_name| %>
                  <div class="form-check">
                    <%= check_box_tag "columns[]", column, @columns_preferences.preferred.include?(column), id: "column_\#{column}", class: "form-check-input" %>
                    <%= form.label "column_\#{column}", column_name, class: "form-check-label" %>
                  </div>
                <% end %>
              </fieldset>
            </div>
            <div class="modal-footer">
              <%= form.submit t("action.apply"), name: "save", class: "btn btn-primary" %>
              <% end %>

              <%= form_with url: @action_path, method: :get do |form| %>
                <%= form.submit t("action.reset"), name: "reset", class: "btn btn-link" %>
              <% end %>
            </div>
          </div>
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
