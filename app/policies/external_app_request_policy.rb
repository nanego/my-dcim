# frozen_string_literal: true

class ExternalAppRequestPolicy < ApplicationPolicy
  pre_check :deny_readers
end
