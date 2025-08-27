# frozen_string_literal: true

class ExternalAppRecordPolicy < ApplicationPolicy
  pre_check :deny_readers
end
