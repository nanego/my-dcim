# frozen_string_literal: true

class ColumnsPreferenceComponent < ApplicationComponent
  def initialize(action_path, columns, displayed_columns)
    @action_path = action_path
    @columns = columns
    @displayed_columns = displayed_columns

    super
  end

  def call
    concat save_form
    concat reset_form
  end

  private

  def save_form
    form_with(url: @action_path, method: :get) do |f|
      safe_join([
                  content_tag(:fieldset, class: "form-floating") do
                    concat(f.collection_select(:columns, @columns,
                                               :first,
                                               :second,
                                               { prompt: true, multiple: true, selected: @displayed_columns },
                                               { class: "form-select", data: { controller: :select } }))
                    concat f.label :columns
                  end,

                  f.submit("Apply"),
                  f.submit("Apply and save", name: "save"),
                ])
    end
  end

  def reset_form
    form_with(url: @access_control, method: :get) do |f|
      f.submit("Reset preferences", name: "reset")
    end
  end
end
