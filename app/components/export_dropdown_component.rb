# frozen_string_literal: true

class ExportDropdownComponent < ApplicationComponent
  erb_template <<~ERB
    <div class="dropdown">
      <button class="btn btn-outline-primary dropdown-toggle btn-sm d-flex align-items-center"
              type="button"
              data-bs-toggle="dropdown"
              aria-expanded="false">
        <span class="bi bi-filetype-csv me-1"></span>
        <%= t("export_button.exports.csv") %>
      </button>

      <ul class="dropdown-menu dropdown-menu-end">
        <% if @pagy.next %>
          <li>
            <%= link_to t(".export.current_page"), current_page_export(format: :csv), class: "dropdown-item" %>
          </li>
        <% end %>
        <li>
          <%= link_to t(".export.all_pages"), all_pages_export(format: :csv), class: "dropdown-item" %>
        </li>
      </ul>
    </div>
  ERB

  def initialize(url:, pagy:, **params)
    @url = url
    @pagy = pagy
    @params = params

    super()
  end

  private

  def current_page_export(format:)
    params = @params.dup
    params[@pagy.vars[:page_param].to_s] = @pagy.page
    public_send(@url, format:, **params)
  end

  def all_pages_export(format:)
    public_send(@url, format:, **@params.except(@pagy.vars[:page_param].to_s))
  end
end
