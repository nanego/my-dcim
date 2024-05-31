# frozen_string_literal: true

module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      @prefilled_data = nil
      render partial: (association.to_s.singularize + "_fields"), locals: { f: builder }
    end
    link_to(name, '#', class: "add_fields btn btn-outline-secondary btn-sm",
                       data: { id:, fields: fields.gsub("\n", "") })
  end

  def link_to_add_fields_with_prefilled_data(name, f, association, prefilled_data)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      with_prefilled_data(prefilled_data) do
        render partial: (association.to_s.singularize + "_fields"), locals: { f: builder }
      end
    end
    link_to(name, '#', class: "add_fields btn btn-outline-secondary btn-sm",
                       data: { id:, fields: fields.gsub("\n", "") })
  end

  private

  def with_prefilled_data(prefilled_data)
    @prefilled_data = prefilled_data
    result = yield
    @prefilled_data = nil

    result
  end
end
