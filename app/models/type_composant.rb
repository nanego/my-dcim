# frozen_string_literal: true

class TypeComposant < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  has_changelog

  has_many :components, class_name: "EnclosureComponent"
end
