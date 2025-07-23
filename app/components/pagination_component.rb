# frozen_string_literal: true

class PaginationComponent < ApplicationComponent
  include Pagy::Frontend

  erb_template <<~ERB
    <div class="pagination-component">
      <%== pagy_bootstrap_nav(@pagy) %>

      <div class="d-flex align-items-baseline gap-2">
        <%= label_tag :items_per_page, t(".items_per_page"), class: "form-label text-nowrap text-secondary" %>
        <%= select_tag(
            :items_per_page,
            options_for_select(options, selected_items_per_page),
            onchange: "window.location.href = this.value",
            class: "form-select form-select-sm"
          ) %>
      </div>
    </div>
  ERB

  def initialize(pagy:, params: nil)
    @pagy = pagy
    @params = params

    super
  end

  private

  def options
    @options ||= User::AVAILABLE_ITEMS_PER_PAGE.index_with do |item|
      url_for(pagy_params_for_items(item))
    end
  end

  def pagy_params_for_items(size)
    (@params || request.query_parameters).merge(@pagy.vars[:limit_param] => size, @pagy.vars[:page_param] => 1)
  end

  def selected_items_per_page
    options[@pagy.limit]
  end
end
