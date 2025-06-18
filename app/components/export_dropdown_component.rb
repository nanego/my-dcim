# frozen_string_literal: true

class ExportDropdownComponent < ApplicationComponent
  erb_template <<~ERB
    <div class="dropdown">
      <button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
        <%= t("export_button.exports.csv") %>
      </button>

      <ul class="dropdown-menu dropdown-menu-end">
        <li>
          <%= link_to t("export_button.page.current"), current_page_export(format: :csv), class: "dropdown-item" %>
        </li>
        <li>
          <%= link_to t("export_button.page.all"), all_pages_export(format: :csv), class: "dropdown-item" %>
        </li>
      </ul>
    </div>
  ERB

  def initialize(url:)
    @url = url

    super
  end

  private

  def current_page_export(format:)
    public_send(@url, page: params[:page] || 1, format:)
  end

  def all_pages_export(format:)
    public_send(@url, format:)
  end
end
