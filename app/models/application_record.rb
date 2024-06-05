# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Changelogable
  include ActiveRecord::Normalization

  primary_abstract_class

  self.store_attribute_unset_values_fallback_to_default = true
end
