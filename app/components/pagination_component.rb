# frozen_string_literal: true

class PaginationComponent < ApplicationComponent
  include Pagy::Frontend

  erb_template <<~ERB
    <div class="pagination-component">
      <%== pagy_bootstrap_nav(@pagy) %>

      <div class="d-flex align-items-baseline gap-2">
        <label for="items-per-page" class="form-label text-nowrap text-secondary">
          <%= t(".items_per_page") %>
        </label>
        <select id="items-per-page" class="form-select form-select-sm" onchange="window.location.href = this.value;">
          <% User::AVAILABLE_ITEMS_PER_PAGE.each do |size| %>
            <option value="<%= url_for(pagy_params_for_items(size)) %>" <%= 'selected' if size == @pagy.limit %>>
              <%= size %>
            </option>
          <% end %>
        </select>
      </div>
    </div>
  ERB

  def initialize(pagy:, params:)
    @pagy = pagy
    @params = params

    super
  end

  def render?
    @pagy.pages > 1
  end

  private

  def pagy_params_for_items(size)
    @params.to_unsafe_h.merge(limit: size, page: 1)
  end
end
