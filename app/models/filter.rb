# frozen_string_literal: true

class Filter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  extend ActiveModel::Translation

  attr_accessor :name
end
