# frozen_string_literal: true

module ColumnsPreference
  extend ActiveSupport::Concern

  included do
    before_action :set_displayed_columns, only: :index

    private

    def set_displayed_columns
      model = controller_path.classify.constantize

      @displayed_columns = search_params[:columns] || model::DEFAULT_COLUMNS_PREFERENCE
      @displayed_associations_columns = @displayed_columns.select { |col| col.include? "." }
                                                          .map do |col|
                                                            k, v = col.split('.', 2)
                                                            { k.to_sym => v.to_sym }
                                                          end
    end
  end
end
