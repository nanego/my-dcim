# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Changelogable
  include ActiveRecord::Normalization

  primary_abstract_class
end
