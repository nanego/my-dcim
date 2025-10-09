# frozen_string_literal: true

module FormHelper
  def redirect_to_on_success_hidden_field_tag(redirect_to_on_success)
    hidden_field_tag(:redirect_to_on_success, redirect_to_on_success) if redirect_to_on_success
  end

  def pagy_to_hidden_fields(pagy)
    hash_to_hidden_fields(
      pagy.vars[:limit_param] => pagy.vars[pagy.vars[:limit_param]],
    )
  end

  def query_parameters_to_hidden_fields
    hash_to_hidden_fields(request.query_parameters)
  end

  def hash_to_hidden_fields(hash)
    cleaned_hash = hash.compact
    pairs        = cleaned_hash.to_query.split(Rack::Utils::DEFAULT_SEP)

    tags = pairs.map do |pair|
      key, value = pair.split("=", 2).map { |str| Rack::Utils.unescape(str) }
      hidden_field_tag(key, value, id: nil)
    end

    tags.join("\n").html_safe # rubocop:disable Rails/OutputSafety
  end
end
