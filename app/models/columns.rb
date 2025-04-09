# frozen_string_literal: true

class Columns
  def initialize(query, columns, default_columns, controller)
    @query = query
    @columns = columns
    @default_columns = default_columns
    @controller = controller
    @model = query.model
  end

  def perform
      model_associations = @model.reflect_on_all_associations.map(&:name).map(&:to_s)

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

  private

  def displayed_columns
    @displayed_columns ||= @columns || @controller.session[session_model_key] || @default_columns
  end

  def session_model_key
    @model.model_name.to_s.downcase.to_sym
  end
end
