# frozen_string_literal: true

module ColumnsPreference
  extend ActiveSupport::Concern

  included do
    before_action :set_displayed_columns, only: :index

    private

    def set_displayed_columns
      @displayed_columns = search_params[:columns] || controller_path.classify.constantize::DEFAULT_COLUMNS_PREFERENCE
    end
  end
end
