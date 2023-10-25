# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Changelogable

  primary_abstract_class
end
