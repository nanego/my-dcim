# frozen_string_literal: true

class ExportDropdownComponent < ApplicationComponent
  erb_template <<~ERB
    <div class="dropdown">
      <button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
        <%= t("export_button.exports.csv") %>
      </button>

      <ul class="dropdown-menu dropdown-menu-end">
        <li>
          <%= link_to t("export_button.page.current"), @page_url, class: "dropdown-item" %>
        </li>
        <li>
          <%= link_to t("export_button.page.all"), @url, class: "dropdown-item" %>
        </li>
      </ul>
    </div>
  ERB

  def initialize(url:, page_url:)
    @url = url
    @page_url = page_url

    super
  end
end
