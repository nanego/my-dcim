# frozen_string_literal: true

class PaginationComponent < ApplicationComponent
  include Pagy::Frontend

  erb_template <<~ERB
    <%== pagy_bootstrap_nav(@pagy) %>
  ERB

  def initialize(pagy)
    @pagy = pagy

    super
  end

  def call?
    @pagy.pages > 1
  end
end
