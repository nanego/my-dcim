# frozen_string_literal: true

class ColumnsPreferenceComponent < ApplicationComponent
  def initialize(model, action_path, available_columns, displayed_columns)
    @model = model
    @action_path = action_path
    @available_columns = available_columns
    @displayed_columns = displayed_columns

    super
  end

  def call
    safe_join([
                form_with(url: @action_path, method: :get) do |f|
                  safe_join([
                              content_tag(:fieldset, class: "form-floating") do
                                concat(f.collection_select(:columns, @available_columns.index_with { |c| @model.human_attribute_name(c) },
                                                           :first,
                                                           :second,
                                                           { prompt: true, multiple: true, selected: @displayed_columns },
                                                           { class: "form-select", data: { controller: :select } }))
                                concat f.label :columns
                              end,

                              f.submit("Apply"),
                              f.submit("Apply and save", name: "save"),
                            ])
                end,

                form_with(url: @access_control, method: :get) do |f|
                  f.submit("Reset preferences", name: "Reset")
                end,
              ])
  end
end
