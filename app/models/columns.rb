# frozen_string_literal: true

class Columns
  def initialize(query, params, default_columns, available_columns)
    @query = query
    @params = params
    @default_columns = default_columns
    @available_columns = available_columns
    @model = query.model
  end

  def perform
      model_associations = @model.reflect_on_all_associations.map(&:name).map(&:to_s)

      # Columns
      displayed_columns = @params[:columns] || @default_columns
      # Associations
      displayed_associations = displayed_columns & model_associations
      # Associations' attributes
      displayed_associations_attributes = displayed_columns.select { |col| col.include? "." }
                                                          .map do |col|
                                                            k, v = col.split('.', 2)
                                                            { k.to_sym => v.to_sym }
                                                          end
      # Attributes
      displayed_attributes = (displayed_columns - displayed_associations).reject { |c| c.include? "." }

      [@query
        .includes(displayed_associations_attributes, displayed_associations)
        .references(displayed_associations_attributes, displayed_associations)
        .select(displayed_attributes), displayed_columns]
    end
end
