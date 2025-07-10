# frozen_string_literal: true

class PaginationComponent < ApplicationComponent
  include Pagy::Frontend

  DEFAULT_ITEMS_PER_PAGE = 100

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

  def initialize(pagy:, params:, default_limit:)
    @pagy = pagy
    @params = params
    @default_limit = default_limit

    super
  end

  def render?
    @pagy.pages > 1
  end

  private

  def options
    @options ||= User::AVAILABLE_ITEMS_PER_PAGE.index_with do |item|
      url_for(pagy_params_for_items(item))
    end
  end

  def pagy_params_for_items(size)
    @params.merge(@pagy.vars[:limit_param] => size, @pagy.vars[:page_param] => 1)
  end

  def selected_items_per_page
    page_length = @pagy.vars[:limit] || @default_limit
    options[page_length.to_i]
  end
end
